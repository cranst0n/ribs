import 'dart:math';

const total = 100000000;
const chunks = 10000;

final _random = Random();

int calculatePiChunk(int iterations) {
  int insideCircle = 0;

  for (int i = 0; i < iterations; i++) {
    final x = _random.nextDouble();
    final y = _random.nextDouble();

    if ((x * x) + (y * y) <= 1.0) insideCircle++;
  }

  return insideCircle;
}
