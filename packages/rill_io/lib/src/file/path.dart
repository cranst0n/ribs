import 'package:path/path.dart' as p;
import 'package:ribs_core/ribs_core.dart';

extension type Path(String _repr) {
  static Path get current => Path(p.current);

  Path operator +(Path path) => Path(p.join(_repr, path._repr)).normalize;

  Path operator /(String name) => Path(p.join(_repr, name)).normalize;

  Path get absolute => Path(p.absolute(_repr));

  String get extension => p.extension(_repr);

  Path get fileName => Path(p.basename(_repr));

  bool get isAbsolute => p.isAbsolute(_repr);

  IList<Path> get names => p.split(_repr).map((p) => Path(p)).toIList();

  Path get normalize => Path(p.normalize(_repr));

  Option<Path> get parent => Some(Path(p.dirname(_repr))).filter((p) => p._repr != _repr);

  Path relativize(Path path) => Path(p.relative(path._repr, from: _repr));
}
