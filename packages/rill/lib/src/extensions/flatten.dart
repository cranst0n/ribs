import 'package:ribs_rill/ribs_rill.dart';

extension RillFlattenOps<O> on Rill<Rill<O>> {
  Rill<O> flatten() => flatMap((r) => r);
}
