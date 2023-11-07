import 'package:ribs_core/ribs_core.dart';

abstract class PlatformBase {
  IO<Unit> print(String message);
  IO<Unit> println(String message);

  IO<Unit> printErr(String message);
  IO<Unit> printErrLn(String message);

  IO<String> readLine();
}
