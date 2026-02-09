import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

class Counter {
  final Ref<int> ref;

  Counter(this.ref);

  static IO<Counter> create() => Ref.of(0).map(Counter.new);

  IO<int> get count => ref.value();
  IO<Unit> get decrement => ref.update((n) => n - 1);
  IO<Unit> get increment => ref.update((n) => n + 1);
}
