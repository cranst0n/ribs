import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/src/io_platform/io_platform.dart';

class IOPlatformImpl implements IOPlatform {
  @override
  IO<A> isolate<A>(IO<A> io, {String? debugName}) => throw UnimplementedError();

  @override
  IO<Unit> print(String message) => throw UnimplementedError();

  @override
  IO<String> readLine() => throw UnimplementedError();

  @override
  void installFiberDumpSignalHandler() => throw UnimplementedError();
}
