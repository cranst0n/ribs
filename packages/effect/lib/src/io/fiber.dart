part of '../io.dart';

enum FiberState { running, suspended }

/// A handle to a running [IO] that allows for cancelation of the [IO] or
/// waiting for completion.
final class IOFiber<A> {
  static final Set<IOFiber<dynamic>> _activeFibers = {};
  static int _idCounter = 0;

  final IO<A> _startIO;

  // Dump related fields.
  final int id;
  FiberState _state = FiberState.running;
  String _suspensionInfo = "Initializing";

  final _callbacks = Stack<Function1<Outcome<A>, void>>(2);
  final _finalizers = Stack<IO<Unit>>(2);

  /// State to resume fiber when it's next scheduled.
  int _resumeTag = ExecR;

  /// Any associated data to be used when the fiber is resumed.
  Object? _resumeData;

  /// The IO to run when the fiber is resumed.
  IO<dynamic>? _resumeIO;

  /// Tracks the current "generation" of the fiber's execution state.
  ///
  /// This is used to ensure that stale asynchronous resumptions (e.g., from a
  /// delayed Sleep or an Async callback that fires after the fiber has already
  /// been canceled or moved on) are ignored. Each time the fiber suspends or
  /// yields, the generation is incremented, and only callbacks that match the
  /// current generation are permitted to wake the fiber.
  int _resumeGeneration = 0;

  final _conts = ByteStack();
  final _contData = Stack<Object>();

  Fn1<Either<Object, Unit>, void>? _cancelationFinalizer;

  late final _TraceRingBuffer _traceBuffer = _TraceRingBuffer(
    IOTracingConfig.traceBufferSize,
  );

  late IO<Unit> _cancel;
  late IO<Outcome<A>> _join;

  Outcome<A>? _outcome;

  bool _canceled = false;
  int _masks = 0;
  bool _finalizing = false;

  final IORuntime _runtime;
  late final int _autoCedeN;

  IOFiber(
    this._startIO, {
    Function1<Outcome<A>, void>? callback,
    IORuntime? runtime,
  }) : _runtime = runtime ?? IORuntime.defaultRuntime,
       id = _idCounter++ {
    _autoCedeN = _runtime.autoCedeN;
    if (_autoCedeN < 1) throw ArgumentError('Fiber autoCedeN must be > 0');

    _resumeIO = _startIO;

    if (callback != null) {
      _callbacks.push(callback);
    }

    _cancel = IO._uncancelable((_) {
      if (_outcome != null) {
        return IO.unit;
      } else {
        _canceled = true;

        if (_isUnmasked()) {
          return IO._async_((fin) {
            _resumeTag = AsyncContinueCanceledWithFinalizerR;
            _resumeData = Fn1(fin);

            final expectedGen = ++_resumeGeneration;
            _scheduleResume(expectedGen);
          });
        } else {
          return join()._voided();
        }
      }
    });

    _join = IO._async_<Outcome<A>>((cb) => _registerListener((oc) => cb(oc.asRight())));
  }

  /// Creates an [IO] that requsets the fiber be canceled and waits for the
  /// completion/finalization of the fiber.
  IO<Unit> cancel() => _cancel.traced('cancel');

  /// Creates an [IO] that will return the [Outcome] of the fiber when it
  /// completes.
  IO<Outcome<A>> join() => _join.traced('join');

  IO<A> joinWith(IO<A> onCancel) => join()._flatMap((a) => a.embed(onCancel));

  IO<A> joinWithNever() => joinWith(IO.never());

  bool _shouldFinalize() => _canceled && _isUnmasked();
  bool _isUnmasked() => _masks == 0;

  void _scheduleResume(int expectedGen) {
    _runtime.schedule(() {
      if (_resumeGeneration == expectedGen) _resume();
    });
  }

  void _scheduleResumeAfter(Duration duration, int expectedGen) {
    _runtime.scheduleAfter(duration, () {
      if (_resumeGeneration == expectedGen) _resume();
    });
  }

  void _resume() {
    _state = FiberState.running;

    final data = _resumeData;
    _resumeData = null;

    switch (_resumeTag) {
      case ExecR:
        _execR();
      case AsyncContinueSuccessfulR:
        _asyncContinueSuccessfulR(data);
      case AsyncContinueFailedR:
        _asyncContinueFailedR(data!);
      case AsyncContinueCanceledR:
        _asyncContinueCanceledR();
      case AsyncContinueCanceledWithFinalizerR:
        _asyncContinueCanceledWithFinalizerR(data! as Fn1<Either<Object, Unit>, void>);
      case CedeR:
        _cedeR();
      case AutoCedeR:
        _autoCedeR();
      case DoneR:
        break;
    }
  }

  void _run() {
    _activeFibers.add(this); // Register

    final expectedGen = ++_resumeGeneration;
    _scheduleResume(expectedGen);
  }

  void _execR() {
    if (_canceled) {
      _done(Canceled());
    } else {
      _conts.clear();
      _contData.clear();

      _conts.push(_RunTerminusK);

      _finalizers.clear();

      final io = _resumeIO;
      _resumeIO = null;

      _runLoop(io!, _autoCedeN);
    }
  }

  void _asyncContinueSuccessfulR(dynamic value) => _runLoop(_succeeded(value), _autoCedeN);

  void _asyncContinueFailedR(Object error) => _runLoop(_failed(error), _autoCedeN);

  void _asyncContinueCanceledR() {
    final fin = _prepareFiberForCancelation();
    _runLoop(fin, _autoCedeN);
  }

  void _asyncContinueCanceledWithFinalizerR(Fn1<Either<Object, Unit>, void> cb) {
    final fin = _prepareFiberForCancelation(cb);

    _runLoop(fin, _autoCedeN);
  }

  void _cedeR() => _runLoop(_succeeded(Unit()), _autoCedeN);

  void _autoCedeR() {
    final io = _resumeIO;
    _resumeIO = null;

    _runLoop(io!, _autoCedeN);
  }

  void _runLoop(
    IO<dynamic> initial,
    int cedeIterations,
  ) {
    var cur0 = initial;
    int nextCede = cedeIterations;

    runLoop:
    while (true) {
      if (cur0 is _EndFiber) break runLoop;

      if (nextCede <= 0) {
        _resumeTag = AutoCedeR;
        _resumeIO = cur0;
        final expectedGen = ++_resumeGeneration;
        _scheduleResume(expectedGen);
        break runLoop;
      } else if (_shouldFinalize()) {
        cur0 = _prepareFiberForCancelation();
      } else {
        switch (cur0) {
          case _Pure(:final value):
            cur0 = _succeeded(value);
          case _Error(:final error):
            cur0 = _failed(error);
          case _Delay(:final thunk):
            try {
              cur0 = _succeeded(thunk());
            } catch (e) {
              cur0 = _failed(e);
            }
          case _Map(:final ioa, :final f):
            switch (ioa) {
              case _Pure(:final value):
                try {
                  cur0 = _succeeded(f(value));
                } catch (e) {
                  cur0 = _failed(e);
                }
              case _Error(:final error):
                cur0 = _failed(error);
              case _Delay(:final thunk):
                try {
                  cur0 = _succeeded(f(thunk()));
                } catch (e) {
                  cur0 = _failed(e);
                }
              default:
                _conts.push(_MapK);
                _contData.push(f);
                cur0 = ioa;
            }
          case _FlatMap(:final ioa, :final f):
            switch (ioa) {
              case _Pure(:final value):
                try {
                  cur0 = f(value);
                } catch (e) {
                  cur0 = _failed(e);
                }
              case _Error(:final error):
                cur0 = _failed(error);
              case _Delay(:final thunk):
                try {
                  cur0 = f(thunk());
                } catch (e) {
                  cur0 = _failed(e);
                }
              default:
                _conts.push(_FlatMapK);
                _contData.push(f);
                cur0 = ioa;
            }
          case final _Attempt<dynamic> attempt:
            switch (attempt.ioa) {
              case _Pure(:final value):
                cur0 = _succeeded(attempt.right(value));
              case _Error(:final error):
                cur0 = _succeeded(attempt.left(error));
              case _Delay(:final thunk):
                try {
                  cur0 = _succeeded(attempt.right(thunk()));
                } catch (e) {
                  cur0 = _succeeded(attempt.left(e));
                }
              default:
                _conts.push(_AttemptK);
                _contData.push(attempt);

                cur0 = attempt.ioa;
            }
          case _Sleep(:final duration):
            _resumeTag = CedeR;
            final expectedGen = ++_resumeGeneration;
            _scheduleResumeAfter(duration, expectedGen);

            _state = FiberState.suspended;
            _suspensionInfo = "Sleep($duration)";

            break runLoop;
          case _Now():
            cur0 = _succeeded(_runtime.now);
          case _Cede():
            _resumeTag = CedeR;
            final expectedGen = ++_resumeGeneration;
            _scheduleResume(expectedGen);

            _state = FiberState.suspended;
            _suspensionInfo = "AutoCede";

            break runLoop;
          case _HandleErrorWith(:final ioa, :final f):
            _conts.push(_HandleErrorWithK);
            _contData.push(f);
            cur0 = ioa;
          case _OnCancel(:final ioa, :final fin):
            _finalizers.push(fin);
            _conts.push(_OnCancelK);
            cur0 = ioa;
          case _Async(:final body):
            final resultF = cur0.getter();

            // captured when this async node is registered; used to detect stale callbacks
            final expectedGen = ++_resumeGeneration;

            IO<Option<IO<Unit>>> finF;

            try {
              finF = body((result) {
                // A generation mismatch means the fiber has moved on since this
                // async callback was registered — e.g. the fiber was canceled
                // and rescheduled, or the _Async node was abandoned due to
                // autoCede. Invoking the callback now would resume the wrong
                // logical state, so we discard it.
                if (_resumeGeneration != expectedGen) return;

                final nextGen = ++_resumeGeneration;

                resultF.value = result;

                if (!_shouldFinalize()) {
                  result.fold(
                    (err) {
                      _resumeTag = AsyncContinueFailedR;
                      _resumeData = err;
                    },
                    (a) {
                      _resumeTag = AsyncContinueSuccessfulR;
                      _resumeData = a;
                    },
                  );
                } else {
                  _resumeTag = AsyncContinueCanceledR;
                }

                _scheduleResume(nextGen);
              });
            } catch (e) {
              // The async body threw synchronously before ever calling `cb`.
              // Restore generation so any stale scheduled callbacks are ignored,
              // then drive the fiber into the failure path.
              ++_resumeGeneration;
              cur0 = _failed(e);
              break;
            }

            // Ensure we don't cede and potentially miss finalizer registration
            if (nextCede <= 1) nextCede++;

            cur0 = finF._flatMap(
              (finOpt) => finOpt.fold(
                () => resultF,
                (fin) => resultF._onCancel(fin),
              ),
            );
          case _AsyncGet():
            if (cur0.value != null) {
              cur0 = cur0.value!.fold<IO<dynamic>>(
                (err) => _failed(err),
                (value) => _succeeded(value),
              );
            } else {
              // Process of registering async finalizer lands us here before the
              // async callback has a chance to fill in the value, so we need to
              // suspend until it does.
              _state = FiberState.suspended;
              _suspensionInfo = "Async(register: $cur0)";

              break runLoop;
            }
          case _Start():
            final fiber = cur0.createFiber(_runtime);
            fiber._run();
            cur0 = _succeeded(fiber);
          case _Canceled():
            _canceled = true;

            if (_isUnmasked()) {
              final fin = _prepareFiberForCancelation();
              cur0 = fin;
            } else {
              cur0 = _succeeded(Unit());
            }
          case final _RacePair<dynamic, dynamic> rp:
            final next = IO._async_<RacePairOutcome<dynamic, dynamic>>((cb) {
              final fiberA = rp.createFiberA(_runtime, _autoCedeN);
              final fiberB = rp.createFiberB(_runtime, _autoCedeN);

              // callback should be called exactly once, so when one fiber
              // finishes, remove the callback from the other
              fiberA._setCallback((oc) {
                fiberB._setCallback((_) {});
                cb(Right(rp.aWon(oc, fiberB)));
              });

              fiberB._setCallback((oc) {
                fiberA._setCallback((_) {});
                cb(Right(rp.bWon(oc, fiberA)));
              });

              fiberA._run();
              fiberB._run();
            });

            _state = FiberState.suspended;
            _suspensionInfo = "RacePair(Waiting for children)";

            cur0 = next;
          case _Uncancelable(:final body):
            _masks += 1;
            final id = _masks;

            final poll = _RuntimePoll(id, this);

            try {
              cur0 = body(poll);
            } catch (e, stackTrace) {
              cur0 = IO._raiseError(e, stackTrace);
            }

            _conts.push(_UncancelableK);
          case _UnmaskRunLoop(:final ioa, :final id, :final self):
            if (_masks == id && this == self) {
              _masks -= 1;
              _conts.push(_UnmaskK);
            }

            cur0 = ioa;
          case _Traced(:final ioa, :final label):
            // If we encounter a Traced node, we can safely assume that tracing
            // is enabled, since the node would not have been created otherwise.
            _traceBuffer.push(label, _formatLocation(cur0.location, cur0.depth));

            cur0 = ioa;
          case _EndFiber():
            break runLoop;
        }
      }

      nextCede--;
    }
  }

  static final stackFrameId = RegExp(r'^#\d+\s+');
  static String _formatLocation(StackTrace? stackTrace, int? depth) {
    if (stackTrace != null) {
      final frames = stackTrace.toString().split('\n');
      final frameDepth = depth ?? 3;

      return frames.length > frameDepth
          ? frames[frameDepth].replaceFirst(stackFrameId, '').trim()
          : "Unknown";
    } else {
      return '';
    }
  }

  void _registerListener(Function1<Outcome<A>, void> cb) {
    if (_outcome == null) {
      _callbacks.push(cb);
    } else {
      cb(_outcome!);
    }
  }

  void _setCallback(Function1<Outcome<A>, void> cb) {
    _callbacks.clear();
    _callbacks.push(cb);
  }

  IO<dynamic> _prepareFiberForCancelation([
    Fn1<Either<Object, Unit>, void>? cb,
  ]) {
    if (_finalizers.nonEmpty) {
      if (!_finalizing) {
        _finalizing = true;

        _conts.clear();
        _contData.clear();

        _conts.push(_CancelationLoopK);

        _cancelationFinalizer = cb;

        _masks += 1;
      }

      return _finalizers.pop();
    } else {
      cb?.call(Right(Unit()));

      // unblock joiners
      _done(Canceled());

      // exit fiber loop
      return const _EndFiber();
    }
  }

  IO<dynamic> _succeeded(dynamic initialResult) {
    var result = initialResult;

    while (true) {
      final op = _conts.pop();

      switch (op) {
        case _RunTerminusK:
          return _runTerminusSuccessK(result);
        case _MapK:
          final fn = _contData.pop() as Fn1;

          try {
            result = fn(result);
          } catch (e) {
            return _failed(e);
          }
        case _FlatMapK:
          final fn = _contData.pop() as Fn1;

          try {
            return fn(result) as IO<dynamic>;
          } catch (e) {
            return _failed(e);
          }
        case _CancelationLoopK:
          return _cancelationLoopSuccessK();
        case _HandleErrorWithK:
          _contData.pop(); // Discard handler
        case _OnCancelK:
          _finalizers.pop();
        case _UncancelableK:
          _masks -= 1;
        case _UnmaskK:
          _masks += 1;
        case _AttemptK:
          final attempt = _contData.pop() as _Attempt<dynamic>;
          return _succeeded(attempt.right(result));
      }
    }
  }

  IO<dynamic> _failed(Object initialError) {
    var error = initialError;

    while (true) {
      final op = _conts.pop();

      switch (op) {
        case _RunTerminusK:
          return _runTerminusFailureK(error);
        case _MapK:
          _contData.pop(); // Discard function
        case _FlatMapK:
          _contData.pop(); // Discard function
        case _CancelationLoopK:
          return _cancelationLoopFailureK(error);
        case _HandleErrorWithK:
          final fn = _contData.pop() as Fn1<Object, IO<dynamic>>;
          try {
            return fn(error);
          } catch (e) {
            error = e;
          }
        case _OnCancelK:
          _finalizers.pop();
        case _UncancelableK:
          _masks -= 1;
        case _UnmaskK:
          _masks += 1;
        case _AttemptK:
          final attempt = _contData.pop() as _Attempt<dynamic>;
          return _succeeded(attempt.left(error));
      }
    }
  }

  void _done(Outcome<A> oc) {
    _join = IO.pure(oc).traced('join');
    _cancel = IO.pure(Unit()).traced('cancel');

    _outcome = oc;

    _masks = 0;

    _resumeTag = DoneR;
    _resumeIO = null;

    while (_callbacks.nonEmpty) {
      _callbacks.pop()(oc);
    }

    _activeFibers.remove(this); // Deregister
  }

  IO<dynamic> _runTerminusSuccessK(dynamic result) {
    _done(Succeeded(result as A));
    return const _EndFiber();
  }

  IO<dynamic> _runTerminusFailureK(Object error) {
    Object finalError = error;

    if (IOTracingConfig.tracingEnabled) {
      finalError = IOTracedException(error, _traceBuffer.toList());
    }

    _done(Errored(finalError));

    return const _EndFiber();
  }

  IO<dynamic> _cancelationLoopSuccessK() {
    if (_finalizers.nonEmpty) {
      // still more finalizers to execute
      _conts.push(_CancelationLoopK);
      return _finalizers.pop();
    } else {
      // last finalizer has finished running...
      _cancelationFinalizer?.call(Right<Object, Unit>(Unit()));

      _done(Canceled());

      return const _EndFiber();
    }
  }

  IO<dynamic> _cancelationLoopFailureK(Object err) => _cancelationLoopSuccessK();

  static void dumpFibers() {
    // ignore: avoid_print
    void doPrint(String message) => print(message);

    doPrint("\n===== FIBER DUMP (${_activeFibers.length} active) ===================");
    for (final fiber in _activeFibers) {
      final status =
          fiber._state == FiberState.running
              ? "RUNNING (or scheduled)"
              : "SUSPENDED: ${fiber._suspensionInfo}";

      doPrint("Fiber #${fiber.id} [$status]");

      // Print Trace (Reverse order for readability: Top of stack first)
      final trace = fiber._traceBuffer.toList().reversed;

      if (trace.isEmpty) {
        doPrint("  (No trace)");
      } else {
        for (final line in trace) {
          final char = line == trace.last ? "╰" : "├";
          doPrint("  $char  at $line");
        }
      }
      doPrint(""); // Spacer
    }
    doPrint("================================================\n");
  }
}

extension JoinWithUnitOps on IOFiber<Unit> {
  IO<Unit> joinWithUnit() => joinWith(IO.unit);
}

const ExecR = 0;
const AsyncContinueSuccessfulR = 1;
const AsyncContinueFailedR = 2;
const AsyncContinueCanceledR = 3;
const AsyncContinueCanceledWithFinalizerR = 4;
const BlockingR = 5;
const CedeR = 6;
const AutoCedeR = 7;
const DoneR = 8;

const int _RunTerminusK = 0;
const int _MapK = 1;
const int _FlatMapK = 2;
const int _CancelationLoopK = 3;
const int _HandleErrorWithK = 4;
const int _OnCancelK = 5;
const int _UncancelableK = 6;
const int _UnmaskK = 7;
const int _AttemptK = 8;
