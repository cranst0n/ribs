import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

abstract class Barrier {
  static IO<Barrier> create(int initialLimit) => throw UnimplementedError();

  IO<int> get limit;

  IO<Unit> setLimit(int n);

  IO<Unit> updateLimit(Function1<int, int> f);

  IO<Unit> get enter;

  IO<Unit> get exit;
}
