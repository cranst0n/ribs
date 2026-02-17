part of 'rill.dart';

class RillCompile<O> {
  final Pull<O, Unit> _pull;

  RillCompile(this._pull);

  IO<int> get count => foldChunks(0, (acc, chunk) => acc + chunk.size);

  IO<Unit> get drain => foldChunks(Unit(), (_, _) => Unit());

  IO<B> fold<B>(B init, Function2<B, O, B> f) =>
      foldChunks(init, (acc, chunk) => chunk.foldLeft(acc, f));

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

  IO<Option<O>> get last => foldChunks(none(), (acc, chunk) => chunk.lastOption.orElse(() => acc));

  IO<O> get lastOrError => last.flatMap(
    (opt) => opt.fold(
      () => IO.raiseError('Rill.compile.lastOrError: no element'),
      (last) => IO.pure(last),
    ),
  );

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

  RillResourceCompile<O> get resource => RillResourceCompile(_pull);

  IO<IList<O>> get toList => foldChunks(IList.empty<O>(), (acc, chunk) => acc.concat(chunk));

  IO<IVector<O>> get toVector => foldChunks(IVector.empty<O>(), (acc, chunk) => acc.concat(chunk));
}

extension RillCompilerStringOps on RillCompile<String> {
  IO<String> get string => foldChunks(
    StringBuffer(),
    (buf, chunk) => buf..writeAll(chunk.toList()),
  ).map((buf) => buf.toString());
}

class RillResourceCompile<O> {
  final Pull<O, Unit> _pull;

  RillResourceCompile(this._pull);

  Resource<int> get count => foldChunks(0, (acc, chunk) => acc + chunk.size);

  Resource<Unit> get drain => foldChunks(Unit(), (_, _) => Unit());

  Resource<B> fold<B>(B init, Function2<B, O, B> f) =>
      foldChunks(init, (acc, chunk) => chunk.foldLeft(acc, f));

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

  Resource<Option<O>> get last =>
      foldChunks(none(), (acc, chunk) => chunk.lastOption.orElse(() => acc));

  Resource<O> get lastOrError => last.evalMap(
    (opt) => opt.fold(
      () => IO.raiseError('Rill.compile.lastOrError: no element'),
      (last) => IO.pure(last),
    ),
  );

  Resource<O> get onlyOrError {
    return foldChunks(none<O>(), (acc, chunk) {
      if (chunk.isEmpty) {
        return acc;
      } else if (acc.isDefined || chunk.size > 1) {
        throw 'Expected singleton rill';
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

  Resource<IList<O>> get toList => foldChunks(IList.empty<O>(), (acc, chunk) => acc.concat(chunk));

  Resource<IVector<O>> get toVector =>
      foldChunks(IVector.empty<O>(), (acc, chunk) => acc.concat(chunk));
}
