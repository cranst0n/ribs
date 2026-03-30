// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';

// #region prism-domain
// A sealed hierarchy representing a configuration value that can be
// a String, an int, or a boolean.
sealed class ConfigValue {}

final class CString extends ConfigValue {
  final String value;
  CString(this.value);
}

final class CInt extends ConfigValue {
  final int value;
  CInt(this.value);
}

final class CBool extends ConfigValue {
  final bool value;
  CBool(this.value);
}
// #endregion prism-domain

// #region prism-define
// A Prism<S, A> focuses on one variant of a sum type.
// It requires two functions:
//   getOrModify : S -> Either<S, A>   (Right if the variant matches, Left otherwise)
//   reverseGet  : A -> S              (construct the variant from A)

final stringP = Prism<ConfigValue, String>(
  (cv) => switch (cv) {
    CString(:final value) => Right(value),
    _ => Left(cv),
  },
  CString.new,
);

final intP = Prism<ConfigValue, int>(
  (cv) => switch (cv) {
    CInt(:final value) => Right(value),
    _ => Left(cv),
  },
  CInt.new,
);

final boolP = Prism<ConfigValue, bool>(
  (cv) => switch (cv) {
    CBool(:final value) => Right(value),
    _ => Left(cv),
  },
  CBool.new,
);
// #endregion prism-define

// #region prism-use
void prismUsage() {
  final ConfigValue cv = CString('hello');

  // getOption — Some when the variant matches, None otherwise
  final str = stringP.getOption(cv); // Some('hello')
  final num = intP.getOption(cv); // None

  // reverseGet — always constructs the target variant
  final constructed = intP.reverseGet(42); // CInt(42)

  // modify — no-op when the variant does not match
  final upper = stringP.modify((s) => s.toUpperCase())(cv); // CString('HELLO')
  final unchanged = intP.modify((n) => n + 1)(cv); // CString('hello') — no match

  // replace — convenience shorthand for modify((_) => value)
  final replaced = stringP.replace('world')(cv); // CString('world')
}
// #endregion prism-use

// #region prism-compose
// andThenP composes two Prisms: both variants must match for the result to succeed.
final positiveIntP = Prism<ConfigValue, int>(
  (cv) => switch (cv) {
    CInt(:final value) when value > 0 => Right(value),
    _ => Left(cv),
  },
  CInt.new,
).andThenP(
  Prism<int, String>(
    (i) => i > 0 ? Right(i.toString()) : Left(i),
    (s) => int.parse(s),
  ),
);

void composeUsage() {
  final cv = CInt(7);
  final str = positiveIntP.getOption(cv); // Some('7')

  final neg = CInt(-1);
  final noStr = positiveIntP.getOption(neg); // None
}

// #endregion prism-compose
