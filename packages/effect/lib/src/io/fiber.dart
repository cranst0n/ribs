part of '../io.dart';

/// A handle to a running [IO] that allows for cancelation of the [IO] or
/// waiting for completion.
final class IOFiber<A> {
  final IO<A> _startIO;

  final _callbacks = Stack<Function1<Outcome<A>, void>>();
  final _finalizers = Stack<IO<Unit>>();

  _Resumption _resumeTag = const _ExecR();
  IO<dynamic>? _resumeIO;

  final _conts = Stack<_Continuation>();

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

  static const int _DefaultMaxStackDepth = 512;

  final IORuntime _runtime;
  late final int _autoCedeN;

  IOFiber(
    this._startIO, {
    Function1<Outcome<A>, void>? callback,
    IORuntime? runtime,
  }) : _runtime = runtime ?? IORuntime.defaultRuntime {
    _autoCedeN = _runtime.autoCedeN;
    if (_autoCedeN < 1) throw ArgumentError('Fiber autoCedeN must be > 0');

    _resumeIO = _startIO;

    if (callback != null) {
      _callbacks.push(callback);
    }

    _cancel = IO._uncancelable((_) {
      _canceled = true;

      if (_isUnmasked()) {
        return IO._async_((fin) {
          _resumeTag = _AsyncContinueCanceledWithFinalizerR(Fn1(fin));
          _runtime.schedule(_resume);
        });
      } else {
        return join()._voided();
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

  void _resume() {
    switch (_resumeTag) {
      case _ExecR():
        _execR();
      case _AsyncContinueSuccessfulR(:final value):
        _asyncContinueSuccessfulR(value);
      case _AsyncContinueFailedR(:final error):
        _asyncContinueFailedR(error);
      case _AsyncContinueCanceledR():
        _asyncContinueCanceledR();
      case _AsyncContinueCanceledWithFinalizerR(:final fin):
        _asyncContinueCanceledWithFinalizerR(fin);
      case _CedeR():
        _cedeR();
      case _AutoCedeR():
        _autoCedeR();
      case _DoneR():
        break;
    }
  }

  void _execR() {
    if (_canceled) {
      _done(Canceled());
    } else {
      _conts.clear();
      _conts.push(const _RunTerminusK());

      _finalizers.clear();

      final io = _resumeIO;
      _resumeIO = null;

      _runLoop(io!, _autoCedeN);
    }
  }

  void _asyncContinueSuccessfulR(dynamic value) => _runLoop(_succeeded(value, 0), _autoCedeN);

  void _asyncContinueFailedR(Object error) => _runLoop(_failed(error, 0), _autoCedeN);

  void _asyncContinueCanceledR() {
    final fin = _prepareFiberForCancelation();
    _runLoop(fin, _autoCedeN);
  }

  void _asyncContinueCanceledWithFinalizerR(Fn1<Either<Object, Unit>, void> cb) {
    final fin = _prepareFiberForCancelation(cb);

    _runLoop(fin, _autoCedeN);
  }

  void _cedeR() => _runLoop(_succeeded(Unit(), 0), _autoCedeN);

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
        _resumeTag = const _AutoCedeR();
        _resumeIO = cur0;
        _runtime.schedule(_resume);
        break runLoop;
      } else if (_shouldFinalize()) {
        cur0 = _prepareFiberForCancelation();
      } else {
        switch (cur0) {
          case _Pure(:final value):
            cur0 = _succeeded(value, 0);
          case _Error(:final error):
            cur0 = _failed(error, 0);
          case _Delay(:final thunk):
            cur0 = Either.catching(
              () => thunk(),
              (a, b) => (a, b),
            ).fold<IO<dynamic>>(
              (err) => _failed(err.$1, 0),
              (v) => _succeeded(v, 0),
            );
          case _Map(:final ioa, :final f):
            IO<dynamic> next(Function0<dynamic> value) =>
                Either.catching(() => f(value()), (a, b) => (a, b)).fold<IO<dynamic>>(
                  (err) => _failed(err.$1, 0),
                  (v) => _succeeded(v, 0),
                );

            switch (ioa) {
              case _Pure(:final value):
                cur0 = next(() => value);
              case _Error(:final error):
                cur0 = _failed(error, 0);
              case _Delay(:final thunk):
                cur0 = next(thunk.call);
              default:
                _conts.push(_MapK(f));
                cur0 = ioa;
            }
          case _FlatMap(:final ioa, :final f):
            IO<dynamic> next(Function0<dynamic> value) => Either.catching(
              () => f(value()),
              (a, b) => (a, b),
            ).fold((err) => _failed(err.$1, 0), identity);

            switch (ioa) {
              case _Pure(:final value):
                cur0 = next(() => value);
              case _Error(:final error):
                cur0 = _failed(error, 0);
              case _Delay(:final thunk):
                cur0 = next(thunk.call);
              default:
                _conts.push(_FlatMapK(f));
                cur0 = ioa;
            }
          case _Attempt(:final ioa):
            switch (ioa) {
              case _Pure(:final value):
                cur0 = _succeeded(cur0.right(value), 0);
              case _Error(:final error):
                cur0 = _succeeded(cur0.left(error), 0);
              case _Delay(:final thunk):
                dynamic result;
                Object? error;

                try {
                  result = thunk();
                } catch (e) {
                  error = e;
                }

                cur0 =
                    error == null
                        ? _succeeded(cur0.right(result), 0)
                        : _succeeded(cur0.left(error), 0);
              default:
                final attempt = cur0;
                // Push this function on to allow proper type tagging when running
                // the continuation
                _conts.push(
                  _AttemptK(
                    Fn1((x) => attempt.right(x)),
                    Fn1((x) => attempt.left(x)),
                  ),
                );

                cur0 = ioa;
            }
          case _Sleep(:final duration):
            _resumeTag = const _CedeR();
            _runtime.scheduleAfter(duration, _resume);
            break runLoop;
          case _Now():
            cur0 = _succeeded(_runtime.now, 0);
          case _Cede():
            _resumeTag = const _CedeR();
            _runtime.schedule(_resume);
            break runLoop;
          case _HandleErrorWith(:final ioa, :final f):
            _conts.push(_HandleErrorWithK(f));
            cur0 = ioa;
          case _OnCancel(:final ioa, :final fin):
            _finalizers.push(fin);
            _conts.push(const _OnCancelK());
            cur0 = ioa;
          case _Async(:final body):
            final resultF = cur0.getter();

            final finF = body((result) {
              resultF.value = result;

              if (!_shouldFinalize()) {
                result.fold(
                  (err) => _resumeTag = _AsyncContinueFailedR(err),
                  (a) => _resumeTag = _AsyncContinueSuccessfulR(a),
                );
              } else {
                _resumeTag = const _AsyncContinueCanceledR();
              }

              _runtime.schedule(_resume);
            });

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
                (err) => _failed(err, 0),
                (value) => _succeeded(value, 0),
              );
            } else {
              // Process of registering async finalizer lands us here
              break runLoop;
            }
          case _Start():
            final fiber = cur0.createFiber(_runtime);
            _runtime.schedule(fiber._resume);
            cur0 = _succeeded(fiber, 0);
          case _Canceled():
            _canceled = true;

            if (_isUnmasked()) {
              final fin = _prepareFiberForCancelation();
              cur0 = fin;
            } else {
              cur0 = _succeeded(Unit(), 0);
            }
          case final _RacePair<dynamic, dynamic> rp:
            final next = IO.async_<RacePairOutcome<dynamic, dynamic>>((cb) {
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

              _runtime.schedule(fiberA._resume);
              _runtime.schedule(fiberB._resume);
            });

            cur0 = next;
          case _Uncancelable(:final body):
            _masks += 1;
            final id = _masks;

            final poll = Poll._(id, this);

            try {
              cur0 = body(poll);
            } catch (e, stackTrace) {
              cur0 = IO._raiseError(e, stackTrace);
            }

            _conts.push(const _UncancelableK());
          case _UnmaskRunLoop(:final ioa, :final id, :final self):
            if (_masks == id && this == self) {
              _masks -= 1;
              _conts.push(const _UnmaskK());
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
        _conts.push(const _CancelationLoopK());

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

  IO<dynamic> _succeeded(dynamic result, int depth) {
    final kont = _conts.pop();

    switch (kont) {
      case _RunTerminusK():
        return _runTerminusSuccessK(result);
      case _MapK<dynamic, dynamic>(:final fn):
        {
          dynamic transformed;
          Object? error;

          try {
            transformed = fn(result);
          } catch (e) {
            error = e;
          }

          if (depth > _DefaultMaxStackDepth) {
            return error == null ? _Pure(transformed) : _Error(error);
          } else {
            return error == null ? _succeeded(transformed, depth + 1) : _failed(error, depth + 1);
          }
        }
      case _FlatMapK<dynamic, dynamic>(:final fn):
        {
          dynamic transformed;
          Object? error;

          try {
            transformed = fn(result);
          } catch (e) {
            error = e;
          }

          return error == null ? transformed as IO<dynamic> : _failed(error, depth + 1);
        }
      case _CancelationLoopK():
        return _cancelationLoopSuccessK();
      case _HandleErrorWithK():
        return _succeeded(result, depth);
      case _OnCancelK():
        _finalizers.pop();
        return _succeeded(result, depth + 1);
      case _UncancelableK():
        _masks -= 1;
        return _succeeded(result, depth + 1);
      case _UnmaskK():
        _masks += 1;
        return _succeeded(result, depth + 1);
      case _AttemptK(:final right):
        return _succeeded(right(result), depth);
    }
  }

  IO<dynamic> _failed(Object error, int depth) {
    var kont = _conts.pop();

    RemoveNodesLoop:
    while (true) {
      switch (kont) {
        case _MapK() || _FlatMapK():
          kont = _conts.pop();
        default:
          break RemoveNodesLoop;
      }
    }

    switch (kont) {
      case _MapK<dynamic, dynamic>():
      case _FlatMapK<dynamic, dynamic>():
        return _failed(error, depth);
      case _RunTerminusK():
        return _runTerminusFailureK(error);
      case _CancelationLoopK():
        return _cancelationLoopFailureK(error);
      case _HandleErrorWithK(:final fn):
        dynamic recovered;
        Object? err;

        try {
          recovered = fn(error);
        } catch (e) {
          err = e;
        }

        return err == null ? recovered as IO<dynamic> : _failed(err, depth + 1);
      case _OnCancelK():
        _finalizers.pop();
        return _failed(error, depth + 1);
      case _UncancelableK():
        _masks -= 1;
        return _failed(error, depth);
      case _UnmaskK():
        _masks += 1;
        return _failed(error, depth);
      case _AttemptK(:final left):
        return _succeeded(left(error), depth);
    }
  }

  void _done(Outcome<A> oc) {
    _join = IO.pure(oc).traced('join');
    _cancel = IO.pure(Unit()).traced('cancel');

    _outcome = oc;

    _masks = 0;

    _resumeTag = const _DoneR();
    _resumeIO = null;

    while (_callbacks.nonEmpty) {
      _callbacks.pop()(oc);
    }
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
      _conts.push(const _CancelationLoopK());
      return _finalizers.pop();
    } else {
      // last finalizer has finished running...
      _cancelationFinalizer?.call(Right<Object, Unit>(Unit()));

      _done(Canceled());

      return const _EndFiber();
    }
  }

  IO<dynamic> _cancelationLoopFailureK(Object err) => _cancelationLoopSuccessK();
}
