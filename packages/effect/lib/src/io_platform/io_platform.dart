import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/src/io_platform/io_platform_stub.dart';

abstract class IOPlatform {
  factory IOPlatform() => IOPlatformImpl();

  IO<A> isolate<A>(IO<A> io, {String? debugName});

  IO<Unit> print(String message);

  IO<String> readLine();

  void installFiberDumpSignalHandler();
}
