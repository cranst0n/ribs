import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/test.dart';

import 'package:ribs_rill/src/signal.dart';
import 'package:test/test.dart';

void main() {
  test(
    'SignallingRef.tryModify works correctly',
    () {
      final test = SignallingRef.of(0).flatMap((ref) {
        // Attempt to modify optimistically
        return ref
            .tryModify((current) {
              if (current < 10) {
                return (current + 1, "incremented");
              } else {
                return (current, "limit reached"); // No change
              }
            })
            .flatMap((result) {
              if (result.isDefined && result.getOrElse(() => "") == "incremented") {
                return IO.unit;
              } else {
                return IO.raiseError<Unit>(
                  Exception("Expected Some('incremented'), got $result"),
                );
              }
            });
      });

      expect(test, ioSucceeded());
    },
  );
}
