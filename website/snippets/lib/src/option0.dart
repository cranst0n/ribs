import 'package:ribs_core/ribs_core.dart';

/// basic example

Option<int> parseString(String s) => Option(int.tryParse(s));

/// basic example

/// something else

final x = parseString('123').map((a) => a + 1); // enter
final y = x.getOrElse(() => 4);                 // exit

/// something else
