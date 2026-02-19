// ignore_for_file: avoid_print

import 'package:ribs_effect/ribs_effect.dart';

final nFib = BigInt.from(1000000);

void main(List<String> args) async {
  final io = fib(nFib, BigInt.zero, BigInt.one);
  final result = await io.unsafeRunFuture();

  print('[io] ${nFib}th fibonacci number has ${result.toString().length} digits');
}

IO<BigInt> fib(BigInt n, BigInt a, BigInt b) {
  return IO.delay(() => a + b).flatMap((b2) {
    return n > BigInt.zero ? fib(n - BigInt.one, b, b2) : IO.pure(b2);
  });
}
