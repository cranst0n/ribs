const nElements = 10000000;

void main(List<String> args) async {
  final stream = Stream.fromIterable(
    Iterable.generate(
      nElements,
      (i) => i,
    ).map((x) => x * 2).where((x) => x % 3 == 0).take(50000000),
  );

  await for (final _ in stream) {}
}
