import 'package:ribs_core/src/option.dart';

extension OptionSyntaxOps<A> on A {
  Option<A> get some => Some(this);
}
