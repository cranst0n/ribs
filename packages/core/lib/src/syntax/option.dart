import 'package:ribs_core/ribs_core.dart';

part 'generated/option_tuple.dart';
part 'generated/tuple_option.dart';

extension OptionSyntaxOps<A> on A {
  /// Lifts this value into an [Option], specifically a [Some].
  Option<A> get some => Some(this);
}
