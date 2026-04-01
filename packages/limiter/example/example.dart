// ignore_for_file: avoid_print
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_limiter/ribs_limiter.dart';

// Simulates calling an external API that enforces a rate limit.
// Uses ribs_limiter to ensure we never exceed one request per 200ms
// and no more than 3 concurrent in-flight requests.

IO<String> fetchUser(int id) {
  return IO.sleep(const Duration(milliseconds: 50)).productR(IO.pure('User($id)'));
}

void main() async {
  final program = Limiter.start(
    const Duration(milliseconds: 200),
    maxConcurrent: 3,
    maxQueued: 20,
  ).use((limiter) {
    final userIds = ilist([1, 2, 3, 4, 5, 6, 7, 8]);

    // Submit all requests through the limiter concurrently.
    // The limiter ensures at most 3 run at once and at least
    // 200ms elapses between each dequeue.
    final fetches = userIds.map(
      (id) => limiter.submit(
        fetchUser(id).flatTap((user) => IO.print('Fetched: $user')),
      ),
    );

    return fetches
        .parSequence()
        .flatTap(
          (results) => IO.print('\nAll done. Results: ${results.toList()}'),
        )
        .flatMap((_) {
          // Demonstrate dynamic reconfiguration mid-flight.
          return limiter
              .setMinInterval(const Duration(milliseconds: 50))
              .productR(IO.print('\nSlowed down — interval now 50ms'))
              .productR(
                limiter.submit(
                  IO.print('Extra request after reconfigure').as('done'),
                ),
              );
        });
  });

  await program.unsafeRunFuture();
}
