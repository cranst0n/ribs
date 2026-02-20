import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

abstract class PlatformBase {
  IO<A> isolate<A>(IO<A> io, {String? debugName});

  IO<Unit> print(String message);

  IO<String> readLine();

  void installFiberDumpSignalHandler();
}
