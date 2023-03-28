import 'dart:async';
import 'dart:io' show stderr, stdin, stdout;

import 'package:async/async.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/internal/stack.dart';

typedef IOError = Tuple2<Object, StackTrace>;

typedef AsyncCallback<A> = Function1<Either<IOError, A>, void>;
typedef AsyncBody<A> = Function1<AsyncCallback<A>, void>;
typedef AsyncBodyWithFin<A> = Function1<AsyncCallback<A>, IO<Option<IO<Unit>>>>;

typedef AWon<A, B> = Tuple2<Outcome<A>, IOFiber<B>>;
typedef BWon<A, B> = Tuple2<IOFiber<A>, Outcome<B>>;
typedef RacePairOutcome<A, B> = Either<AWon<A, B>, BWon<A, B>>;

abstract class IO<A> extends Monad<A> {
  static IO<A> async<A>(AsyncBodyWithFin<A> k) => _Async(k);

  static IO<A> async_<A>(AsyncBody<A> k) => _Async((cb) {
        k(cb);
        return none();
      });

  static IO<Tuple2<A, B>> both<A, B>(IO<A> ioa, IO<B> iob) => IO.uncancelable(
        (poll) => poll(racePair(ioa, iob)).flatMap(
          (winner) => winner.fold(
            (aWon) => aWon((oca, f) {
              return oca.fold(
                () => f
                    .cancel()
                    .productR(() => poll(IO.canceled))
                    .productR(() => IO.never()),
                (err) => f.cancel().productR(() => IO.raiseError(err)),
                (a) => poll(f.join())
                    .onCancel(f.cancel())
                    .flatMap((ocb) => ocb.fold(
                          () => poll(IO.canceled).productR(() => IO.never()),
                          (err) => IO.raiseError(err),
                          (b) => IO.pure(Tuple2(a, b)),
                        )),
              );
            }),
            (bWon) => bWon((f, ocb) {
              return ocb.fold(
                () => f
                    .cancel()
                    .productR(() => poll(IO.canceled))
                    .productR(() => IO.never()),
                (err) => f.cancel().productR(() => IO.raiseError(err)),
                (b) => poll(f.join())
                    .onCancel(f.cancel())
                    .flatMap((oca) => oca.fold(
                          () => poll(IO.canceled).productR(() => IO.never()),
                          (err) => IO.raiseError(err),
                          (a) => IO.pure(Tuple2(a, b)),
                        )),
              );
            }),
          ),
        ),
      );

  static IO<Tuple2<Outcome<A>, Outcome<B>>> bothOutcome<A, B>(
    IO<A> ioa,
    IO<B> iob,
  ) =>
      IO.uncancelable(
        (poll) => poll(racePair(ioa, iob)).flatMap(
          (winner) => winner.fold(
            (aWon) => aWon(
                (a, f) => poll(f.join()).onCancel(f.cancel()).tupleLeft(a)),
            (bWon) => bWon(
                (f, b) => poll(f.join()).onCancel(f.cancel()).tupleRight(b)),
          ),
        ),
      );

  static IO<B> bracketFull<A, B>(
    Function1<Poll, IO<A>> acquire,
    Function1<A, IO<B>> use,
    Function1<Tuple2<A, Outcome<B>>, IO<Unit>> release,
  ) =>
      IO.uncancelable(
        (poll) => acquire(poll).flatMap(
          (a) => IO
              .defer(() => poll(use(a)))
              .guaranteeCase((oc) => release(Tuple2(a, oc))),
        ),
      );

  static IO<Unit> canceled = _Canceled();

  static IO<Unit> cede = _Cede();

  static IO<A> defer<A>(Function0<IO<A>> thunk) => delay(thunk).flatten();

  static IO<A> delay<A>(Function0<A> thunk) => _Delay(Fn0(thunk));

  static IO<Unit> exec<A>(Function0<A> thunk) => _Delay(Fn0(thunk)).voided();

  static IO<A> fromCancelableOperation<A>(IO<CancelableOperation<A>> op) {
    return op.flatMap((op) {
      return IO.async((cb) {
        return IO.delay(() {
          op.then(
            (a) => cb(a.asRight()),
            onError: (e, s) => cb(Tuple2(e, s).asLeft()),
          );

          return IO
              .fromFuture(IO.delay(() => op.cancel().then((_) => Unit())))
              .some;
        });
      });
    });
  }

  static IO<A> fromEither<A>(Either<Object, A> either) =>
      either.fold((e) => IO.raiseError<A>(e), IO.pure);

  static IO<A> fromFuture<A>(IO<Future<A>> fut) {
    return fut.flatMap((f) {
      return async_<A>((cb) {
        f.whenComplete(
          () => f.then(
            (a) => cb(a.asRight()),
            onError: (Object e, StackTrace s) => cb(Tuple2(e, s).asLeft()),
          ),
        );
      });
    });
  }

  static IO<A> fromOption<A>(Option<A> option, Function0<Object> orElse) =>
      option.fold(() => IO.raiseError<A>(orElse()), IO.pure);

  static IO<A> never<A>() => async_((_) {});

  static IO<Option<A>> none<A>() => IO.pure(None<A>());

  static IO<DateTime> now = IO.delay(() => DateTime.now());

  static IO<Unit> print(String message) => IO.exec(() => stdout.write(message));

  static IO<Unit> println(String message) =>
      IO.exec(() => stdout.writeln(message));

  static IO<Unit> printErr(String message) =>
      IO.exec(() => stderr.write(message));

  static IO<Unit> printErrLn(String message) =>
      IO.exec(() => stderr.writeln(message));

  static IO<A> pure<A>(A a) => _Pure(a);

  static IO<Either<A, B>> race<A, B>(IO<A> ioa, IO<B> iob) => IO.uncancelable(
        (poll) => poll(IO.racePair(ioa, iob)).flatMap(
          (winner) {
            return winner.fold(
              (aWon) => aWon((oc, fiberB) {
                return oc.fold(
                  () => fiberB.cancel().productR(() => fiberB.join()).flatMap(
                        (oc) => oc.fold(
                          () => poll(IO.canceled).productR(() => IO.never()),
                          (err) => IO.raiseError(err),
                          (b) => IO.pure(Right(b)),
                        ),
                      ),
                  (err) => fiberB.cancel().productR(() => IO.raiseError(err)),
                  (a) => fiberB.cancel().as(Left(a)),
                );
              }),
              (bWon) => bWon((fiberA, oc) {
                return oc.fold(
                  () => fiberA.cancel().productR(() => fiberA.join()).flatMap(
                        (oc) => oc.fold(
                          () => poll(IO.canceled).productR(() => IO.never()),
                          (err) => IO.raiseError(err),
                          (a) => IO.pure(Left(a)),
                        ),
                      ),
                  (err) => fiberA.cancel().productR(() => IO.raiseError(err)),
                  (b) => fiberA.cancel().as(Right(b)),
                );
              }),
            );
          },
        ),
      );

  static IO<Either<Outcome<A>, Outcome<B>>> raceOutcome<A, B>(
    IO<A> ioa,
    IO<B> iob,
  ) =>
      IO.uncancelable(
          (poll) => poll(racePair(ioa, iob)).flatMap((winner) => winner.fold(
                (aWon) => aWon((a, f) => f.cancel().as(Left(a))),
                (bWon) => bWon((f, b) => f.cancel().as(Right(b))),
              )));

  static IO<Either<AWon<A, B>, BWon<A, B>>> racePair<A, B>(
          IO<A> ioa, IO<B> iob) =>
      _RacePair(ioa, iob);

  static IO<A> raiseError<A>(Object err, [StackTrace? trace]) =>
      _Error(Tuple2(err, trace ?? StackTrace.current));

  static IO<Unit> raiseUnless(bool cond, Function0<IOError> e) =>
      IO.unlessA(cond, () => e()((o, s) => IO.raiseError<Unit>(o, s)));

  static IO<Unit> raiseWhen(bool cond, Function0<IOError> e) =>
      IO.whenA(cond, () => e()((o, s) => IO.raiseError<Unit>(o, s)));

  // Would be nice if there was an async way to do this
  static IO<String> readLine() =>
      IO.delay(() => stdin.readLineSync()).flatMap((l) =>
          Option.of(l).fold(() => IO.raiseError('stdin line ended'), IO.pure));

  static IO<Unit> sleep(Duration duration) => _Sleep(duration);

  static IO<Option<A>> some<A>(A a) => IO.pure(Some(a));

  static IO<A> uncancelable<A>(Function1<Poll, IO<A>> body) =>
      _Uncancelable(body);

  static IO<Unit> unit = IO.pure(Unit());

  static IO<Unit> unlessA<A>(bool cond, Function0<IO<A>> action) =>
      cond ? IO.unit : action().voided();

  static IO<Unit> whenA<A>(bool cond, Function0<IO<A>> action) =>
      cond ? action().voided() : IO.unit;

  IO<A> andWait(Duration duration) => flatTap((_) => IO.sleep(duration));

  IO<B> as<B>(B b) => map((_) => b);

  IO<Either<IOError, A>> attempt() => _Attempt(this);

  IO<B> bracket<B>(Function1<A, IO<B>> use, Function1<A, IO<Unit>> release) =>
      bracketCase(use, (t) => t((a, _) => release(a)));

  IO<B> bracketCase<B>(
    Function1<A, IO<B>> use,
    Function1<Tuple2<A, Outcome<B>>, IO<Unit>> release,
  ) =>
      IO.bracketFull((_) => this, use, release);

  IO<A> debug({String prefix = 'DEBUG'}) =>
      flatTap((a) => IO.println('$prefix: $a'));

  IO<A> delayBy(Duration duration) => IO.sleep(duration).productR(() => this);

  @override
  IO<B> flatMap<B>(covariant Function1<A, IO<B>> f) => _FlatMap(this, Fn1(f));

  IO<A> flatTap<B>(covariant Function1<A, IO<B>> f) =>
      flatMap((a) => f(a).as(a));

  IO<A> guarantee(IO<Unit> fin) => onCancel(fin)
      .onError((e) => fin.productR(() => IO.raiseError(e)))
      .productL(() => fin);

  IO<A> guaranteeCase(Function1<Outcome<A>, IO<Unit>> fin) =>
      onCancel(fin(const Canceled()))
          .onError((e) => fin(Errored(e)))
          .flatTap((a) => fin(Succeeded(a)));

  IO<A> handleError(Function1<IOError, A> f) =>
      handleErrorWith((e) => IO.pure(f(e)));

  IO<A> handleErrorWith(covariant Function1<IOError, IO<A>> f) =>
      _HandleErrorWith(this, Fn1(f));

  @override
  IO<B> map<B>(covariant Function1<A, B> f) => _Map(this, Fn1(f));

  IO<A> onCancel(IO<Unit> fin) => _OnCancel(this, fin);

  IO<A> onError(covariant Function1<IOError, IO<Unit>> f) => handleErrorWith(
      (e) => f(e).attempt().productR(() => IO.raiseError<A>(e.$1, e.$2)));

  IO<A> orElse(Function0<IO<A>> that) => handleErrorWith((_) => that());

  IO<Tuple2<A, B>> product<B>(IO<B> that) =>
      flatMap((a) => that.map((b) => Tuple2(a, b)));

  IO<A> productL<B>(Function0<IO<B>> that) => flatMap((a) => that().as(a));

  IO<B> productR<B>(Function0<IO<B>> that) => flatMap((_) => that());

  IO<B> redeem<B>(Function1<IOError, B> recover, Function1<A, B> map) =>
      attempt().map((a) => a.fold(recover, map));

  IO<B> redeemWith<B>(
    Function1<IOError, IO<B>> recover,
    Function1<A, IO<B>> bind,
  ) =>
      attempt().flatMap((a) => a.fold(recover, bind));

  IO<IList<A>> replicate(int n) => n <= 0
      ? IO.pure(nil())
      : flatMap((a) => replicate(n - 1).map((l) => l.prepend(a)));

  IO<Unit> replicate_(int n) =>
      n <= 0 ? IO.unit : flatMap((_) => replicate_(n - 1));

  IO<IOFiber<A>> start() => _Start<A>(this);

  IO<Tuple2<Duration, A>> timed() => Tuple3(now, this, now).mapN(
      (startTime, a, endTime) => Tuple2(endTime.difference(startTime), a));

  IO<A> timeout(Duration duration) => timeoutTo(duration,
      IO.defer(() => IO.raiseError(TimeoutException(duration.toString()))));

  IO<A> timeoutTo(Duration duration, IO<A> fallback) =>
      IO.race(this, IO.sleep(duration)).flatMap((winner) => winner.fold(
            (a) => IO.pure(a),
            (_) => fallback,
          ));

  IO<Tuple2<B, A>> tupleLeft<B>(B b) => map((a) => Tuple2(b, a));

  IO<Tuple2<A, B>> tupleRight<B>(B b) => map((a) => Tuple2(a, b));

  IO<Unit> voided() => as(Unit());

  void unsafeRunAsync(
    Function1<Outcome<A>, void> cb, {
    int autoCedeN = IOFiber.DefaultAutoCedeN,
  }) =>
      IOFiber(
        this,
        callback: (a) => a.fold(
          () => cb(const Canceled()),
          (err) => cb(Errored(err)),
          (a) => cb(Succeeded(a)),
        ),
        autoCedeN: autoCedeN,
      ).schedule();

  void unsafeRunAndForget({int autoCedeN = IOFiber.DefaultAutoCedeN}) =>
      IOFiber(this, autoCedeN: autoCedeN).schedule();

  Future<Outcome<A>> unsafeRunToFutureOutcome({
    int autoCedeN = IOFiber.DefaultAutoCedeN,
  }) {
    final completer = Completer<Outcome<A>>();
    unsafeRunAsync(completer.complete, autoCedeN: autoCedeN);
    return completer.future;
  }

  Future<A> unsafeRunToFuture({int autoCedeN = IOFiber.DefaultAutoCedeN}) {
    final completer = Completer<A>();

    unsafeRunAsync(
      (outcome) => outcome.fold(
        () => completer.completeError('Fiber canceled'),
        (err) => completer.completeError(err.$1, err.$2),
        (a) => completer.complete(a),
      ),
      autoCedeN: autoCedeN,
    );

    return completer.future;
  }
}

extension IONestedOps<A> on IO<IO<A>> {
  IO<A> flatten() => flatMap(id);
}

extension IOBoolOps on IO<bool> {
  IO<B> ifM<B>(Function0<IO<B>> ifTrue, Function0<IO<B>> ifFalse) =>
      flatMap((b) => b ? ifTrue() : ifFalse());
}

extension IOErrorOps<A> on IO<Either<IOError, A>> {
  IO<A> rethrowError() => flatMap(IO.fromEither);
}

// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////               /////////////////////////////////
// /////////////////////////////  Interpreter  /////////////////////////////////
// /////////////////////////////               /////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////

/// Utility class to create unmasked blocks within an uncancelable region
class Poll {
  final int _id;
  final IOFiber<dynamic> _fiber;

  Poll._(this._id, this._fiber);

  IO<A> call<A>(IO<A> ioa) => _UnmaskRunLoop(ioa, _id, _fiber);
}

class _Pure<A> extends IO<A> {
  final A value;

  _Pure(this.value);

  @override
  String toString() => 'Pure($value)';
}

class _Error<A> extends IO<A> {
  final IOError error;

  _Error(this.error);

  @override
  String toString() => 'Error(${error.$1})';
}

class _Delay<A> extends IO<A> {
  final Fn0<A> thunk;

  _Delay(this.thunk);

  @override
  String toString() => 'Delay($thunk)';
}

class _Async<A> extends IO<A> {
  final AsyncBodyWithFin<A> body;

  _Async(this.body);

  _AsyncGet<A> getter() => _AsyncGet();

  @override
  String toString() => 'Async($body)';
}

class _AsyncGet<A> extends IO<A> {
  Either<IOError, dynamic>? value;

  _AsyncGet();

  @override
  String toString() => 'AsyncResultF($value)';
}

class _Map<A, B> extends IO<B> {
  final IO<A> ioa;
  final Fn1<A, B> f;

  _Map(this.ioa, this.f);

  @override
  String toString() => 'Map($ioa, $f)';
}

class _FlatMap<A, B> extends IO<B> {
  final IO<A> ioa;
  final Fn1<A, IO<B>> f;

  _FlatMap(this.ioa, this.f);

  @override
  String toString() => 'FlatMap($ioa, $f)';
}

class _Attempt<A> extends IO<Either<IOError, A>> {
  final IO<A> ioa;

  Either<IOError, A> right(dynamic value) => Right<IOError, A>(value as A);
  Either<IOError, A> left(IOError error) => Left<IOError, A>(error);

  _Attempt(this.ioa);

  @override
  String toString() => 'Attempt($ioa)';
}

class _Sleep extends IO<Unit> {
  final Duration duration;

  _Sleep(this.duration);

  @override
  String toString() => 'Sleep($duration)';
}

class _Cede extends IO<Unit> {
  _Cede();

  @override
  String toString() => 'Cede';
}

class _Start<A> extends IO<IOFiber<A>> {
  final IO<A> ioa;

  _Start(this.ioa);

  IOFiber<A> createFiber() => IOFiber<A>(ioa);

  @override
  String toString() => 'Start($ioa)';
}

class _HandleErrorWith<A> extends IO<A> {
  final IO<A> ioa;
  final Fn1<IOError, IO<A>> f;

  _HandleErrorWith(this.ioa, this.f);

  @override
  String toString() => 'HandleErrorWith($ioa, $f)';
}

class _OnCancel<A> extends IO<A> {
  final IO<A> ioa;
  final IO<Unit> fin;

  _OnCancel(this.ioa, this.fin);

  @override
  String toString() => 'OnCancel($ioa, $fin)';
}

class _Canceled extends IO<Unit> {
  @override
  String toString() => 'Canceled';
}

class _RacePair<A, B> extends IO<RacePairOutcome<A, B>> {
  final IO<A> ioa;
  final IO<B> iob;

  _RacePair(this.ioa, this.iob);

  IOFiber<A> _createFiberA() => IOFiber(ioa);
  IOFiber<B> _createFiberB() => IOFiber(iob);

  RacePairOutcome<A, B> aWon(
    Outcome<dynamic> oc,
    IOFiber<dynamic> fiberB,
  ) =>
      Left(Tuple2(oc as Outcome<A>, fiberB as IOFiber<B>));

  RacePairOutcome<A, B> bWon(
    Outcome<dynamic> oc,
    IOFiber<dynamic> fiberA,
  ) =>
      Right(Tuple2(fiberA as IOFiber<A>, oc as Outcome<B>));

  @override
  String toString() => 'RacePair<$A, $B>($ioa, $iob)';
}

class _Uncancelable<A> extends IO<A> {
  final Function1<Poll, IO<A>> body;

  _Uncancelable(this.body);

  @override
  String toString() => 'Uncancelable<$A>($body)';
}

class _UnmaskRunLoop<A> extends IO<A> {
  final IO<A> ioa;
  final int id;
  final IOFiber<dynamic> self;

  _UnmaskRunLoop(this.ioa, this.id, this.self);

  @override
  String toString() => 'UnmaskRunLoop<$A>($ioa, $id)';
}

class _EndFiber extends IO<dynamic> {
  @override
  String toString() => 'EndFiber';
}

class IOFiber<A> {
  final IO<A> _startIO;

  final _callbacks = Stack<Function1<Outcome<A>, void>>();
  final _finalizers = Stack<IO<Unit>>();

  var _resumeTag = _Resume.Exec;
  IO<dynamic>? _resumeIO;

  var _finalizing = false;

  final _conts = Stack<_Cont>();
  final _objectState = Stack<dynamic>();

  late IO<Unit> _cancel;
  late IO<Outcome<A>> _join;

  Outcome<A>? _outcome;

  bool _canceled = false;
  int _masks = 0;

  static const int _DefaultMaxStackDepth = 512;
  static const int DefaultAutoCedeN = 512;

  final int _autoCedeN;

  void schedule() {
    Future(() => _resume());
  }

  IOFiber(
    this._startIO, {
    Function1<Outcome<A>, void>? callback,
    int autoCedeN = DefaultAutoCedeN,
  }) : _autoCedeN = autoCedeN {
    if (_autoCedeN < 1) throw ArgumentError('Fiber autoCedeN must be > 0');

    _resumeIO = _startIO;

    if (callback != null) {
      _callbacks.push(callback);
    }

    _conts.push(_Cont.RunTerminus);

    _cancel = IO.uncancelable((_) {
      _canceled = true;

      if (_isUnmasked()) {
        return IO.async_((fin) {
          _resumeTag = _Resume.AsyncContinueCanceledWithFinalizer;
          _objectState.push(Fn1(fin));
          schedule();
        });
      } else {
        return join().voided();
      }
    });

    _join = IO.async_((cb) {
      _registerListener((oc) => cb(oc.asRight()));
    });
  }

  IO<Unit> cancel() => _cancel;

  IO<Outcome<A>> join() => _join;

  bool _shouldFinalize() => _canceled && _isUnmasked();
  bool _isUnmasked() => _masks == 0;

  void _rescheduleFiber([
    Duration duration = Duration.zero,
  ]) =>
      Future.delayed(duration, () => _resume());

  void _resume() {
    switch (_resumeTag) {
      case _Resume.Exec:
        _execR();
        break;
      case _Resume.AsyncContinueSuccessful:
        _asyncContinueSuccessfulR();
        break;
      case _Resume.AsyncContinueFailed:
        _asyncContinueFailedR();
        break;
      case _Resume.AsyncContinueCanceled:
        _asyncContinueCanceledR();
        break;
      case _Resume.AsyncContinueCanceledWithFinalizer:
        _asyncContinueCanceledWithFinalizerR();
        break;
      case _Resume.Cede:
        _cedeR();
        break;
      case _Resume.AutoCede:
        _autoCedeR();
        break;
      case _Resume.Done:
        break;
    }
  }

  void _execR() {
    if (_canceled) {
      _done(const Canceled());
    } else {
      _conts.clear();
      _conts.push(_Cont.RunTerminus);

      _objectState.clear();
      _finalizers.clear();

      final io = _resumeIO;
      _resumeIO = null;

      _runLoop(io!, _autoCedeN);
    }
  }

  void _asyncContinueSuccessfulR() =>
      _runLoop(_succeeded(_objectState.pop(), 0), _autoCedeN);

  void _asyncContinueFailedR() =>
      _runLoop(_failed(_objectState.pop() as IOError, 0), _autoCedeN);

  void _asyncContinueCanceledR() {
    final fin = _prepareFiberForCancelation();
    _runLoop(fin, _autoCedeN);
  }

  void _asyncContinueCanceledWithFinalizerR() {
    final cb = _objectState.pop() as Fn1<Either<IOError, Unit>, void>;
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

    while (true) {
      if (cur0 is _EndFiber) {
        break;
      }

      if (nextCede <= 0) {
        _resumeTag = _Resume.AutoCede;
        _resumeIO = cur0;

        _rescheduleFiber();
        break;
      } else if (_shouldFinalize()) {
        cur0 = _prepareFiberForCancelation();
      } else {
        if (cur0 is _Pure) {
          ///////////////////////// PURE /////////////////////////
          cur0 = _succeeded(cur0.value, 0);
        } else if (cur0 is _Error) {
          ///////////////////////// ERROR /////////////////////////
          cur0 = _failed(cur0.error, 0);
        } else if (cur0 is _Delay) {
          ///////////////////////// DELAY /////////////////////////
          cur0 = Either.catching(
                  () => (cur0 as _Delay).thunk(), (a, b) => Tuple2(a, b))
              .fold<IO<dynamic>>(
            (err) => _failed(err, 0),
            (v) => _succeeded(v, 0),
          );
        } else if (cur0 is _Map) {
          ///////////////////////// MAP /////////////////////////
          final ioa = cur0.ioa;
          final f = cur0.f;

          IO<dynamic> next(Function0<dynamic> value) =>
              Either.catching(() => f(value()), (a, b) => Tuple2(a, b))
                  .fold<IO<dynamic>>(
                      (err) => _failed(err, 0), (v) => _succeeded(v, 0));

          if (ioa is _Pure) {
            cur0 = next(() => ioa.value);
          } else if (ioa is _Error) {
            cur0 = _failed(ioa.error, 0);
          } else if (ioa is _Delay) {
            cur0 = next(ioa.thunk);
          } else {
            _objectState.push(f);
            _conts.push(_Cont.Map);

            cur0 = ioa;
          }
        } else if (cur0 is _FlatMap) {
          ///////////////////////// FLATMAP /////////////////////////
          final ioa = cur0.ioa;
          final f = cur0.f;

          IO<dynamic> next(Function0<dynamic> value) =>
              Either.catching(() => f(value()), (a, b) => Tuple2(a, b))
                  .fold((err) => _failed(err, 0), id);

          if (ioa is _Pure) {
            cur0 = next(() => ioa.value);
          } else if (ioa is _Error) {
            cur0 = _failed(ioa.error, 0);
          } else if (ioa is _Delay) {
            cur0 = next(ioa.thunk);
          } else {
            _objectState.push(Fn1(f));
            _conts.push(_Cont.FlatMap);

            cur0 = ioa;
          }
        } else if (cur0 is _Attempt) {
          ///////////////////////// ATTEMPT /////////////////////////
          final ioa = cur0.ioa;

          if (ioa is _Pure) {
            cur0 = _succeeded(cur0.right(ioa.value), 0);
          } else if (ioa is _Error) {
            cur0 = _succeeded(cur0.left(ioa.error), 0);
          } else if (ioa is _Delay) {
            dynamic result;
            IOError? error;

            try {
              result = ioa.thunk();
            } catch (e, s) {
              error = Tuple2(e, s);
            }

            cur0 = error == null
                ? _succeeded(cur0.right(result), 0)
                : _succeeded(cur0.left(error), 0);
          } else {
            final attempt = cur0;
            // Push this function on to allow proper type tagging when running
            // the continuation
            _objectState.push(Fn1((x) => attempt.right(x)));
            _conts.push(_Cont.Attempt);
            cur0 = ioa;
          }
        } else if (cur0 is _Sleep) {
          _resumeTag = _Resume.Cede;
          _rescheduleFiber(cur0.duration);
          break;
        } else if (cur0 is _Cede) {
          _resumeTag = _Resume.Cede;
          _rescheduleFiber();
          break;
        } else if (cur0 is _HandleErrorWith) {
          _objectState.push(cur0.f);
          _conts.push(_Cont.HandleErrorWith);

          cur0 = cur0.ioa;
        } else if (cur0 is _OnCancel) {
          _finalizers.push(cur0.fin);
          _conts.push(_Cont.OnCancel);

          cur0 = cur0.ioa;
        } else if (cur0 is _Async) {
          final io = cur0;

          final resultF = io.getter();

          final finF = io.body((result) {
            resultF.value = result;

            if (!_shouldFinalize()) {
              result.fold(
                (err) {
                  _resumeTag = _Resume.AsyncContinueFailed;
                  _objectState.push(err);
                },
                (a) {
                  _resumeTag = _Resume.AsyncContinueSuccessful;
                  _objectState.push(a);
                },
              );
            } else {
              _resumeTag = _Resume.AsyncContinueCanceled;
            }

            _rescheduleFiber();
          });

          // Ensure we don't cede and potentially miss finalizer registration
          nextCede++;

          cur0 = finF.flatMap((finOpt) => finOpt.fold(
                () => resultF,
                (fin) => resultF.onCancel(fin),
              ));
        } else if (cur0 is _AsyncGet) {
          if (cur0.value != null) {
            cur0 = cur0.value!.fold<IO<dynamic>>(
              (err) => _failed(err, 0),
              (value) => _succeeded(value, 0),
            );
          } else {
            // Process of registering async finalizer lands us here
            break;
          }
        } else if (cur0 is _Start) {
          final fiber = cur0.createFiber();

          fiber.schedule();

          cur0 = _succeeded(fiber, 0);
        } else if (cur0 is _Cede) {
          _rescheduleFiber();
          break;
        } else if (cur0 is _Canceled) {
          _canceled = true;

          if (_isUnmasked()) {
            final fin = _prepareFiberForCancelation();
            cur0 = fin;
          } else {
            cur0 = _succeeded(Unit(), 0);
          }
        } else if (cur0 is _RacePair) {
          final rp = cur0;

          final next = IO.async_<RacePairOutcome<dynamic, dynamic>>((cb) {
            final fiberA = rp._createFiberA();
            final fiberB = rp._createFiberB();

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

            fiberA.schedule();
            fiberB.schedule();
          });

          cur0 = next;
        } else if (cur0 is _Uncancelable) {
          _masks += 1;
          final id = _masks;

          final poll = Poll._(id, this);

          _conts.push(_Cont.Uncancelable);

          cur0 = cur0.body(poll);
        } else if (cur0 is _UnmaskRunLoop) {
          if (_masks == cur0.id && this == cur0.self) {
            _masks -= 1;
            _conts.push(_Cont.Unmask);
          }

          cur0 = cur0.ioa;
        } else {
          throw UnimplementedError('_runLoop: $cur0');
        }
      }

      nextCede--;
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
    Fn1<Either<IOError, Unit>, void>? cb,
  ]) {
    if (_finalizers.isNotEmpty) {
      if (!_finalizing) {
        _finalizing = true;

        _conts.clear();
        _conts.push(_Cont.CancelationLoop);

        _objectState.clear();
        _objectState.push(cb ?? Fn1((_) => Unit()));

        _masks += 1;
      }

      return _finalizers.pop();
    } else {
      cb?.call(Right(Unit()));

      _done(const Canceled());
      return _EndFiber();
    }
  }

  IO<dynamic> _succeeded(dynamic result, int depth) {
    final cont = _conts.pop();

    switch (cont) {
      case _Cont.RunTerminus:
        return _runTerminusSuccessK(result);
      case _Cont.Map:
        {
          final f = _objectState.pop() as Fn1;

          dynamic transformed;
          IOError? error;

          try {
            transformed = f(result);
          } catch (e, s) {
            error = Tuple2(e, s);
          }

          if (depth > _DefaultMaxStackDepth) {
            return error == null ? _Pure(transformed) : _Error(error);
          } else {
            return error == null
                ? _succeeded(transformed, depth + 1)
                : _failed(error, depth + 1);
          }
        }
      case _Cont.FlatMap:
        {
          final f = _objectState.pop() as Fn1;

          dynamic transformed;
          IOError? error;

          try {
            transformed = f(result);
          } catch (e, s) {
            error = Tuple2(e, s);
          }

          return error == null
              ? transformed as IO<dynamic>
              : _failed(error, depth + 1);
        }
      case _Cont.Attempt:
        final f = _objectState.pop() as Fn1;
        return _succeeded(f(result), depth);
      case _Cont.HandleErrorWith:
        _objectState.pop();
        return _succeeded(result, depth);
      case _Cont.OnCancel:
        _finalizers.pop();
        return _succeeded(result, depth + 1);
      case _Cont.CancelationLoop:
        return _cancelationLoopSuccessK();
      case _Cont.Uncancelable:
        _masks -= 1;
        return _succeeded(result, depth + 1);
      case _Cont.Unmask:
        _masks += 1;
        return _succeeded(result, depth + 1);
    }
  }

  IO<dynamic> _failed(IOError error, int depth) {
    var cont = _conts.pop();

    // Drop all the maps / flatMaps since they don't deal with errors
    while (cont == _Cont.Map || cont == _Cont.FlatMap && _conts.isNotEmpty) {
      _objectState.pop();
      cont = _conts.pop();
    }

    switch (cont) {
      case _Cont.Map:
      case _Cont.FlatMap:
        _objectState.pop();
        return _failed(error, depth);
      case _Cont.CancelationLoop:
        return _cancelationLoopFailureK(error);
      case _Cont.RunTerminus:
        return _runTerminusFailureK(error);
      case _Cont.HandleErrorWith:
        final f = _objectState.pop() as Fn1;

        dynamic recovered;
        IOError? err;

        try {
          recovered = f(error);
        } catch (e, s) {
          err = Tuple2(e, s);
        }

        return err == null ? recovered as IO<dynamic> : _failed(err, depth + 1);

      case _Cont.OnCancel:
        _finalizers.pop();
        return _failed(error, depth + 1);
      case _Cont.Uncancelable:
        _masks -= 1;
        return _failed(error, depth + 1);
      case _Cont.Unmask:
        _masks += 1;
        return _failed(error, depth + 1);
      case _Cont.Attempt:
        _objectState.pop();
        return _succeeded(Left<IOError, Never>(error), depth);
    }
  }

  void _done(Outcome<A> oc) {
    _join = IO.pure(oc);
    _cancel = IO.pure(Unit());

    _outcome = oc;

    _masks = 0;

    _resumeTag = _Resume.Done;
    _resumeIO = null;

    while (_callbacks.isNotEmpty) {
      _callbacks.pop()(oc);
    }
  }

  IO<dynamic> _runTerminusSuccessK(dynamic result) {
    _done(Succeeded(result as A));
    return _EndFiber();
  }

  IO<dynamic> _runTerminusFailureK(IOError error) {
    _done(Errored(error));
    return _EndFiber();
  }

  IO<dynamic> _cancelationLoopSuccessK() {
    if (_finalizers.isNotEmpty) {
      _conts.push(_Cont.CancelationLoop);
      return _finalizers.pop();
    } else {
      if (_objectState.isNotEmpty) {
        final cb = _objectState.pop() as Fn1;
        cb.call(Right<IOError, Unit>(Unit()));
      }

      _done(const Canceled());

      return _EndFiber();
    }
  }

  IO<dynamic> _cancelationLoopFailureK(IOError err) =>
      _cancelationLoopSuccessK();
}

// Continuations
enum _Cont {
  Map,
  FlatMap,
  CancelationLoop,
  RunTerminus,
  HandleErrorWith,
  OnCancel,
  Uncancelable,
  Unmask,
  Attempt
}

// Resume
enum _Resume {
  Exec,
  AsyncContinueSuccessful,
  AsyncContinueFailed,
  AsyncContinueCanceled,
  AsyncContinueCanceledWithFinalizer,
  Cede,
  AutoCede,
  Done,
}
