import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/test.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

void main() {
  test('basic example', () {
    final test = Topic.create<String>().flatMap((topic) {
      final publisher = Rill.constant('1').through(topic.publish);
      final subscriber = topic.subscribe(10).take(4);

      return subscriber.concurrently(publisher).compile.toList;
    });

    expect(test, ioSucceeded(ilist(['1', '1', '1', '1'])));
  });
}
