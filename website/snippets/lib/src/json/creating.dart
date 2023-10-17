import 'package:ribs_json/ribs_json.dart';

// creating-1

final anObject = Json.obj([
  ('key1', Json.True),
  ('key2', Json.str('some string...')),
  (
    'key3',
    Json.arr([
      Json.number(123),
      Json.number(3.14),
    ])
  ),
]);

// creating-1

// creating-2

final jsonString = anObject.printWith(Printer.noSpaces);
// {"key1":true,"key2":"some string...","key3":[123,3.14]}

final prettyJsonString = anObject.printWith(Printer.spaces2);
// {
//   "key1" : true,
//   "key2" : "some string...",
//   "key3" : [
//     123,
//     3.14
//   ]
// }

// creating-2
