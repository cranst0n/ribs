import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/views.dart' as views;

mixin View<A> on RibsIterable<A> {
  static View<A> fromIterableProvider<A>(Function0<RibsIterable<A>> iterable) =>
      views.Id(iterable());

  @override
  View<A> view() => this;
}
