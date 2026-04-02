## Unreleased breaking

### Breaking Changes

- Introduce IO runtime.
- Remove `RuntimeException` from IO.
- Make `Ref` abstract.
- Make `Poll` abstract.
- Remove thunk from `IO.productR`/`IO.productL`.
- Change `IO.whenA` to an instance method.
- Rework `IO.print`.
- Reduce arity on some tuple destructuring methods.

### Features

- Introduce `Supervisor` and `Dispatcher`.
- Add `Hotswap` to std.
- Add IO tracing and `IOFiber` dump feature.
- Add `Resource.flatTap`.
- Add missing `mapN`/`flatMapN`/etc. functions to `Resource`.
- Add `IList.parTraverseN`.
- Add equality and hashCode to `ExitCase`.

### Bug Fixes

- Numerous bug fixes.
- Numerous performance improvements.
- Public API and doc cleanups.

## 1.0.0-dev.3

- Update dependencies.

## 1.0.0-dev.2

- Additions: Semaphore, CyclicBarrier, Backpressure
- IO.debug prints regardless of outcome

## 1.0.0-dev.1

- Initial release