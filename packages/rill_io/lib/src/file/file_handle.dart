import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

abstract class FileHandle {
  IO<Unit> flush();

  IO<Option<Chunk<int>>> read(int numBytes, int offset);

  IO<int> get size;

  IO<Unit> truncate(int size);

  IO<int> write(Chunk<int> bytes, int offset);
}
