import 'package:ribs_bench/io/merge_sort/common.dart';

void main(List<String> args) async {
  final unsorted = generateUnsortedList();
  await mergeSortFuture(unsorted, threshold);
}

Future<List<int>> mergeSortFuture(List<int> list, int threshold) async {
  if (list.length <= threshold) {
    final copy = List.of(list);
    copy.sort();
    return copy;
  } else {
    final mid = list.length ~/ 2;

    final left = list.sublist(0, mid);
    final right = list.sublist(mid);

    final leftTask = Future(() => mergeSortFuture(left, threshold));
    final rightTask = Future(() => mergeSortFuture(right, threshold));

    final results = await Future.wait([leftTask, rightTask]);

    return merge(results[0], results[1]);
  }
}
