/// Rate limiting concurrency primitives for the `ribs` ecosystem.
///
/// Provides a token bucket `Limiter` that integrates with `IO` for
/// enforcing rate limits on effectful operations.
library;

export 'src/limiter.dart' show LimitReachedException, Limiter;
