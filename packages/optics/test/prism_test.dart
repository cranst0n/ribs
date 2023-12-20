import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';
import 'package:test/test.dart';

void main() {
  group('Prism', () {
    test('reverseGet', () {
      expect(IntOrString.i.reverseGet(3), I(3));
      expect(IntOrString.s.reverseGet("Yop"), S("Yop"));
    });

    test('andThenP', () {
      final andThen = IntOrString.i
          .andThenP(Prism<int, String>((i) => i.asLeft(), (s) => s.length));

      expect(andThen.reverseGet("a"), I(1));
      expect(andThen.reverseGet("ab"), I(2));
      expect(andThen.reverseGet("abc"), I(3));
    });
  });
}

sealed class IntOrString {
  static final i = Prism<IntOrString, int>(
    (ios) => switch (ios) {
      I(:final i) => Right(i),
      _ => Left(ios),
    },
    I.new,
  );

  static final s = Prism<IntOrString, String>(
    (ios) => switch (ios) {
      S(:final s) => Right(s),
      _ => Left(ios),
    },
    S.new,
  );
}

final class I extends IntOrString {
  final int i;
  I(this.i);

  @override
  bool operator ==(Object that) => that is I && i == that.i;

  @override
  int get hashCode => i.hashCode;
}

final class S extends IntOrString {
  final String s;
  S(this.s);

  @override
  bool operator ==(Object that) => that is S && s == that.s;

  @override
  int get hashCode => s.hashCode;
}
