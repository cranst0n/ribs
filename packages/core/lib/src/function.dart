import 'package:ribs_core/ribs_core.dart';

part 'generated/function_typedefs.dart';
part 'generated/functionc_typedefs.dart';
part 'generated/function_ops.dart';
part 'generated/functionc_ops.dart';

@pragma('vm:prefer-inline')
@pragma('dart2js:tryInline')
T identity<T>(T t) => t;
