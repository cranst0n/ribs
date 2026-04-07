import 'package:ribs_core/ribs_core.dart';

part 'generated/function_typedefs.dart';
part 'generated/functionc_typedefs.dart';
part 'generated/function_ops.dart';
part 'generated/functionc_ops.dart';

/// Returns its argument unchanged.
///
/// Useful as a no-op function value wherever a [Function1] is required.
@pragma('vm:prefer-inline')
@pragma('dart2js:tryInline')
T identity<T>(T t) => t;
