import 'package:ribs_core/src/effect/io.dart';
import 'package:ribs_core/src/effect/platform/base.dart';
import 'package:ribs_core/src/unit.dart';

class PlatformImpl extends PlatformBase {
  @override
  IO<Unit> print(String message) => throw UnimplementedError();

  @override
  IO<Unit> printErr(String message) => throw UnimplementedError();

  @override
  IO<Unit> printErrLn(String message) => throw UnimplementedError();

  @override
  IO<Unit> println(String message) => throw UnimplementedError();

  @override
  IO<String> readLine() => throw UnimplementedError();
}
