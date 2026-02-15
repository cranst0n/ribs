import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

void main() {
  group('Pull runtime casts', () {
    test('append with incompatible types throws TypeError', () {
      final p1 = Pull.output1('hello'); // Pull<String, Unit>

      // We attempt to append a Pull<int, Unit> but force the result to be Pull<int, Unit>.
      // This implicitly tries to cast p1 (Pull<String, Unit>) to Pull<int, Unit>.
      // This should fail because String is not a subtype of int.
      try {
        p1.append<int, Unit>(() => Pull.output1(123));
        fail('Should have thrown TypeError');
      } catch (e) {
        expect(e, isA<TypeError>());
      }
    });

    test('handleErrorWith with incompatible types throws TypeError', () {
      final p1 = Pull.output1('hello'); // Pull<String, Unit>

      // forcing the result type to be Pull<int, Unit> implies p1 must be castable to Pull<int, Unit>
      try {
        p1.handleErrorWith<int>((e) => Pull.output1(123));
        fail('Should have thrown TypeError');
      } catch (e) {
        expect(e, isA<TypeError>());
      }
    });

    test('append with compatible types (widening) works', () {
      final p1 = Pull.output1('hello'); // Pull<String, Unit>

      // Widening to Object
      final p2 = p1.append<Object, Unit>(() => Pull.output1(123));

      expect(p2, isA<Pull<Object, Unit>>());
    });
  });
}
