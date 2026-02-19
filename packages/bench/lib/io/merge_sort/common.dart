import 'dart:math';

const listSize = 10000000;
const threshold = 10000;

final _random = Random();
List<int> generateUnsortedList() => List.generate(listSize, (_) => _random.nextInt(1000000));

List<int> merge(List<int> left, List<int> right) {
  final result = <int>[];

  int i = 0;
  int j = 0;

  while (i < left.length && j < right.length) {
    if (left[i] < right[j]) {
      result.add(left[i++]);
    } else {
      result.add(right[j++]);
    }
  }

  while (i < left.length) {
    result.add(left[i++]);
  }

  while (j < right.length) {
    result.add(right[j++]);
  }

  return result;
}
