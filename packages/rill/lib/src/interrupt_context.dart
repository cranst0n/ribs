import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

typedef InterruptionOutcome = Outcome<UniqueToken>;

final class InterruptContext {
  final Deferred<InterruptionOutcome> deferred;
  final Ref<Option<InterruptionOutcome>> ref;
  final UniqueToken interruptRoot;
  final IO<Unit> cancelParent;

  InterruptContext._(
    this.deferred,
    this.ref,
    this.interruptRoot,
    this.cancelParent,
  );

  static IO<InterruptContext> create(
    UniqueToken newScopeId,
    IO<Unit> cancelParent,
  ) =>
      (Ref.of(none<InterruptionOutcome>()), Deferred.of<InterruptionOutcome>())
          .mapN((ref, deferred) => InterruptContext._(deferred, ref, newScopeId, cancelParent));

  IO<Unit> _complete(InterruptionOutcome outcome) => ref
      .update((a) => a.orElse(() => Some(outcome)))
      .guarantee(deferred.complete(outcome).voided());

  IO<IOFiber<Unit>> completeWhen(IO<InterruptionOutcome> outcome) =>
      outcome.flatMap(_complete).start();

  IO<InterruptContext> childContext(
    bool interruptible,
    UniqueToken newScopeId,
  ) {
    if (interruptible) {
      return deferred.value().start().flatMap((fiber) {
        return InterruptContext.create(newScopeId, fiber.cancel()).flatMap((context) {
          return fiber
              .join()
              .flatMap((outcome) {
                return outcome.fold(
                  () => context._complete(Outcome.canceled()),
                  (err) => context._complete(Outcome.errored(err)),
                  (interrupt) => context._complete(interrupt),
                );
              })
              .start()
              .as(context);
        });
      });
    } else {
      return IO.pure(copy(cancelParent: IO.unit));
    }
  }

  IO<Either<InterruptionOutcome, A>> eval<A>(IO<A> fa) {
    return ref.value().flatMap((outcome) {
      return outcome.fold(
        () => IO.raceOutcome(deferred.value(), fa.attempt()).flatMap((winner) {
          return winner.fold(
            (oc) => oc.embedNever().map((x) => x.asLeft<Never>()),
            (oc) => oc.fold(
              () => IO.canceled.as(Outcome.canceled<Never>().asLeft<Never>()),
              (err) => IO.raiseError<Never>(err),
              (a) => IO.pure(a.leftMap((a) => Outcome.errored(a))),
            ),
          );
        }),
        (oc) => IO.pure(oc.asLeft<Never>()),
      );
    });
  }

  InterruptContext copy({
    Deferred<InterruptionOutcome>? deferred,
    Ref<Option<InterruptionOutcome>>? ref,
    UniqueToken? interruptRoot,
    IO<Unit>? cancelParent,
  }) =>
      InterruptContext._(
        deferred ?? this.deferred,
        ref ?? this.ref,
        interruptRoot ?? this.interruptRoot,
        cancelParent ?? this.cancelParent,
      );
}
