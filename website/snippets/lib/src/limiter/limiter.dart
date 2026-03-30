// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_limiter/ribs_limiter.dart';

// #region limiter-basic
/// A Limiter enforces a minimum gap between job starts and an optional cap
/// on concurrent executions. Jobs are submitted as IO values and executed
/// in a background fiber managed by the Resource.
IO<Unit> limiterBasic() => Limiter.start(200.milliseconds, maxConcurrent: 1).use((limiter) {
  final jobs = ilist(['alpha', 'beta', 'gamma']);
  return jobs.parTraverseIO_(
    (String name) => limiter.submit(IO.print('running: $name')),
  );
});
// #endregion limiter-basic

// #region limiter-api-fetcher
/// Simulates fetching [count] pages from a rate-limited external API.
///
/// * At most [maxConcurrent] requests run simultaneously.
/// * A minimum of [minInterval] elapses between each job start.
/// * Pages with id below [urgentBelow] are submitted at priority 10 and
///   jump ahead of normal-priority work already waiting in the queue.
IO<Unit> apiFetcher({
  int count = 12,
  int maxConcurrent = 2,
  Duration minInterval = const Duration(milliseconds: 150),
  int urgentBelow = 3,
}) => Limiter.start(minInterval, maxConcurrent: maxConcurrent).use((limiter) {
  IO<String> fetchPage(int id) => IO
      .sleep(40.milliseconds)
      .productR(IO.pure('page-$id'))
      .flatTap((String r) => IO.print('fetched: $r'));

  final ids = ilist(List.generate(count, (int i) => i + 1));

  return ids.parTraverseIO_(
    (int id) => limiter.submit(
      fetchPage(id),
      priority: id < urgentBelow ? 10 : 0,
    ),
  );
});
// #endregion limiter-api-fetcher
