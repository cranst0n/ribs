// ignore_for_file: avoid_print

final nFib = BigInt.from(1000000);

void main(List<String> args) async {
  final io = fib(nFib, BigInt.zero, BigInt.one);
  final result = await io;

  print('[io] ${nFib}th fibonacci number has ${result.toString().length} digits');
}

Future<BigInt> fib(BigInt n, BigInt a, BigInt b) {
  return Future(() => a + b).then((b2) {
    return n > BigInt.zero ? fib(n - BigInt.one, b, b2) : Future.value(b2);
  });
}
