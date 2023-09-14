// ignore_for_file: avoid_print, unused_local_variable, unused_element

import 'dart:io';
import 'dart:math';

import 'package:async/async.dart';
import 'package:ribs_core/ribs_core.dart';

Future<void> snippet1() async {
  /// io-1

  final rng = Future(() => Random.secure().nextInt(1000));

  await rng.then((x) => rng.then((y) => print('x: $x / y: $y')));

  /// io-1
}

Future<void> snippet2() async {
  /// io-2

  // Substitute the definition of fut with it's expression
  // x and y are different! (probably)
  await Future(() => Random.secure().nextInt(1000)).then((x) =>
      Future(() => Random.secure().nextInt(1000))
          .then((y) => print('x: $x / y: $y')));

  /// io-2
}

Future<void> snippet3() async {
  /// io-3

  final rng = IO.delay(() => Random.secure().nextInt(1000));

  // x and y are different! (probably)
  await rng
      .flatMap((x) => rng.flatMap((y) => IO.println('x: $x / y: $y')))
      .unsafeRunToFuture();

  /// io-3
}

Future<void> asyncSnippet1() async {
  /// io-async-1

  IO<A> futureToIO<A>(Function0<Future<A>> fut) {
    IO.async_<A>((cb) {
      fut().then(
        (a) => cb(Right(a)),
        onError: (Object err, StackTrace st) => cb(Left(IOError(err, st))),
      );
    });

    throw UnimplementedError();
  }

  /// io-async-1
}

Future<void> errorHandlingSnippet1() async {
  /// error-handling-1

  // composable handler using handleError
  final ioA = IO.delay(() => 90 / 0).handleError((ioError) => 0);
  final ioB = IO
      .delay(() => 90 / 0)
      .handleErrorWith((ioError) => IO.pure(double.infinity));

  IO<double> safeDiv(int a, int b) => IO.defer(() {
        if (b != 0) {
          return IO.pure(a / b);
        } else {
          return IO.raiseError(IOError('cannot divide by 0!'));
        }
      });

  /// error-handling-1
}

void safeResourcesSnippet1() {
  /// safe-resources-1
  final sink = File('path/to/file').openWrite();

  try {
    // use sink...
  } catch (e) {
    // catch error
  } finally {
    sink.close();
  }

  /// safe-resources-1
}

void safeResourcesSnippet2() {
  /// safe-resources-2

  final sink = IO.delay(() => File('path/to/file')).map((f) => f.openWrite());

  // bracket *ensures* that the sink is closed
  final program = sink.bracket(
    (sink) => IO.exec(() => sink.writeAll(['Hello', 'World'])),
    (sink) => IO.exec(() => sink.close()),
  );

  /// safe-resources-2
}

Future<void> conversionsSnippet() async {
  /// conversions-1

  IO.fromOption(const Some(42), () => Exception('raiseError: none'));

  IO.fromEither(Either.right(42));

  IO.fromFuture(IO.delay(() => Future(() => 42)));

  IO.fromCancelableOperation(IO.delay(
    () => CancelableOperation.fromFuture(
      Future(() => 32),
      onCancel: () => print('canceled!'),
    ),
  ));

  /// conversions-1

  /// conversions-bad-future

  final fut = Future(() => print('bad'));

  // Too late! Future is already running!
  final ioBad = IO.fromFuture(IO.pure(fut));

  // IO.pure parameter is not lazy so it's evaluated immediately!
  final ioAlsoBad = IO.fromFuture(IO.pure(Future(() => print('also bad'))));

  // Here we preserve laziness so that ioGood is referentially transparent
  final ioGood = IO.fromFuture(IO.delay(() => Future(() => print('good'))));

  /// conversions-bad-future
}

Future<void> cancelationSnippet() async {
  /// cancelation-1
  int count = 0;

  // Our IO program
  final io = IO
      .pure(42)
      .delayBy(const Duration(seconds: 10))
      .onCancel(IO.exec(() => count += 1))
      .onCancel(IO.exec(() => count += 2))
      .onCancel(IO.exec(() => count += 3));

  // .start() kicks off the IO execution and gives us a handle to that
  // execution in the form of an IOFiber
  final fiber = await io.start().unsafeRunToFuture();

  // We immediately cancel the IO
  fiber.cancel().unsafeRunAndForget();

  // .join() will wait for the fiber to finish
  // In this case, that's immediate since we've canceled the IO above
  final outcome = await fiber.join().unsafeRunToFuture();

  // Show the Outcome of the IO as well as confirmation that our `onCancel`
  // handlers have been called since the IO was canceled
  print('Outcome: $outcome | count: $count'); // Outcome: Canceled | count: 6
  /// cancelation-1
}
