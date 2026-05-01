part of 'rill.dart';

/// Terminal operations for a [Rill] that run the stream and produce an [IO].
///
/// Obtained via [Rill.compile]. Every getter/method here drives the stream to
/// completion inside a managed [Scope] and returns the aggregated result.
class RillCompile<O> {
  final Pull<O, Unit> _pull;

  RillCompile(this._pull);

  /// Counts all emitted elements.
  IO<int> get count => foldChunks(0, (acc, chunk) => acc + chunk.size);

  /// Consumes the stream, discarding all elements.
  IO<Unit> get drain => foldChunks(Unit(), (_, _) => Unit());

  /// Folds the stream element-by-element into a single value.
  IO<B> fold<B>(B init, Function2<B, O, B> f) =>
      foldChunks(init, (acc, chunk) => chunk.foldLeft(acc, f));

  /// Folds the stream chunk-by-chunk into a single value.
  ///
  /// More efficient than [fold] when the accumulation logic can operate on
  /// whole chunks at a time (e.g. appending to a list).
  IO<B> foldChunks<B>(B init, Function2<B, Chunk<O>, B> f) {
    IO<B> go(Pull<O, Unit> currentPull, B currentAcc, Scope scope) {
      return _stepPull(currentPull, scope).flatMap((step) {
        return switch (step) {
          _StepDone<dynamic, dynamic> _ => IO.pure(currentAcc),
          _StepOut<O, Unit> _ => go(step.next, f(currentAcc, step.head), scope),
          final _StepError<dynamic, dynamic> step => IO.raiseError(step.error, step.stackTrace),
        };
      });
    }

    return Resource.makeCase(
      Scope.create(),
      (scope, ec) {
        return scope.close(ec).rethrowError();
      },
    ).use((scope) => go(_pull, init, scope));
  }

  /// Returns the last element emitted, or [none] if the stream was empty.
  IO<Option<O>> get last => foldChunks(none(), (acc, chunk) => chunk.lastOption.orElse(() => acc));

  /// Returns the last element, raising an error if the stream was empty.
  IO<O> get lastOrError => last.flatMap(
    (opt) => opt.fold(
      () => IO.raiseError('Rill.compile.lastOrError: no element'),
      (last) => IO.pure(last),
    ),
  );

  /// Returns the single element emitted, raising an error if the stream emitted
  /// zero or more than one element.
  IO<O> get onlyOrError {
    return foldChunks(none<O>().asRight<Object>(), (acc, chunk) {
      return acc.fold(
        (err) => acc,
        (elem) {
          return elem.fold(
            () {
              if (chunk.size == 1) {
                return Right(chunk.headOption);
              } else if (chunk.nonEmpty) {
                return const Left('Expected singleton rill');
              } else {
                return acc;
              }
            },
            (o) => chunk.isNotEmpty ? const Left('Expected singleton rill') : acc,
          );
        },
      );
    }).rethrowError().flatMap((lastOpt) {
      return lastOpt.fold(
        () => IO.raiseError('Expected singleton rill'),
        (o) => IO.pure(o),
      );
    });
  }

  /// Switches to the resource-based compile API where results are exposed as
  /// [Resource] values whose finalizers close the stream's scope.
  RillResourceCompile<O> get resource => RillResourceCompile(_pull);

  /// Collects all elements into an [IList].
  IO<IList<O>> get toIList => foldChunks(
    IList.builder<O>(),
    (buf, chunk) => buf..addAll(chunk),
  ).map((buf) => buf.toIList());

  /// Collects all elements into an [IVector].
  IO<IVector<O>> get toIVector => foldChunks(
    IVector.builder<O>(),
    (buf, chunk) => buf..addAll(chunk),
  ).map((buf) => buf.result());
}

/// String-specific compile terminals.
extension RillCompilerStringOps on RillCompile<String> {
  /// Concatenates all emitted strings into a single [String].
  IO<String> get string => foldChunks(
    StringBuffer(),
    (buf, chunk) => buf..writeAll(chunk.toList()),
  ).map((buf) => buf.toString());
}

/// Byte-stream compile terminals.
extension RillCompilerIntOps on RillCompile<int> {
  /// Collects all emitted bytes into a [ByteVector].
  IO<ByteVector> get toByteVector =>
      foldChunks(ByteVector.empty, (acc, chunk) => acc.concat(ByteVector.view(chunk.asUint8List)));
}

/// Terminal operations for a [Rill] that expose results as [Resource] values.
///
/// Unlike [RillCompile], which runs the stream inside an [IO], this variant
/// keeps the stream's [Scope] open until the returned [Resource] is released,
/// allowing finalizers to interleave with downstream usage.
///
/// Obtained via [RillCompile.resource].
class RillResourceCompile<O> {
  final Pull<O, Unit> _pull;

  RillResourceCompile(this._pull);

  /// Counts all emitted elements.
  Resource<int> get count => foldChunks(0, (acc, chunk) => acc + chunk.size);

  /// Consumes the stream, discarding all elements.
  Resource<Unit> get drain => foldChunks(Unit(), (_, _) => Unit());

  /// Folds the stream element-by-element into a single value.
  Resource<B> fold<B>(B init, Function2<B, O, B> f) =>
      foldChunks(init, (acc, chunk) => chunk.foldLeft(acc, f));

  /// Folds the stream chunk-by-chunk into a single value.
  Resource<B> foldChunks<B>(B init, Function2<B, Chunk<O>, B> f) {
    final acquire = Scope.create().flatMap((scope) {
      IO<(B, Scope)> runLoop(Pull<O, Unit> currentPull, B acc) {
        return IO.defer(
          () => _stepPull(currentPull, scope).flatMap((step) {
            return switch (step) {
              _StepOut<O, Unit> _ => runLoop(step.next, f(acc, step.head)),
              _StepDone<O, Unit> _ => IO.pure((acc, scope)),
              _StepError<O, Unit> _ => IO.raiseError(step.error, step.stackTrace),
            };
          }),
        );
      }

      return runLoop(_pull, init).handleErrorWith((err) {
        return scope.close(ExitCase.errored(err)).attempt().flatMap((_) => IO.raiseError(err));
      });
    });

    return Resource.makeCase(
      acquire,
      (tuple, exitCase) => tuple.$2.close(exitCase).voided(),
    ).map((tuple) => tuple.$1);
  }

  /// Returns the last element emitted, or [none] if the stream was empty.
  Resource<Option<O>> get last =>
      foldChunks(none(), (acc, chunk) => chunk.lastOption.orElse(() => acc));

  /// Returns the last element, raising an error if the stream was empty.
  Resource<O> get lastOrError => last.evalMap(
    (opt) => opt.fold(
      () => IO.raiseError('Rill.compile.lastOrError: no element'),
      (last) => IO.pure(last),
    ),
  );

  /// Returns the single element emitted, raising an error if the stream emitted
  /// zero or more than one element.
  Resource<O> get onlyOrError {
    return foldChunks(none<O>(), (acc, chunk) {
      if (chunk.isEmpty) {
        return acc;
      } else if (acc.isDefined || chunk.size > 1) {
        throw StateError('Expected singleton rill');
      } else {
        return chunk.headOption;
      }
    }).evalMap((lastOpt) {
      return lastOpt.fold(
        () => IO.raiseError('Expected singleton rill'),
        (o) => IO.pure(o),
      );
    });
  }

  /// Collects all elements into an [IList].
  Resource<IList<O>> get toIList => foldChunks(
    IList.builder<O>(),
    (buf, chunk) => buf..addAll(chunk),
  ).map((buf) => buf.toIList());

  /// Collects all elements into an [IVector].
  Resource<IVector<O>> get toIVector => foldChunks(
    IVector.builder<O>(),
    (buf, chunk) => buf..addAll(chunk),
  ).map((buf) => buf.result());
}
