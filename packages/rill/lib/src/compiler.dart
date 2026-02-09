part of 'rill.dart';

class RillCompile<O> {
  final Pull<O, Unit> _pull;

  RillCompile(this._pull);

  IO<int> get count => foldChunks(0, (acc, chunk) => acc + chunk.size);

  IO<Unit> get drain => foldChunks(Unit(), (_, _) => Unit());

  IO<B> fold<B>(B init, Function2<B, O, B> f) =>
      foldChunks(init, (acc, chunk) => chunk.foldLeft(acc, f));

  IO<B> foldChunks<B>(B init, Function2<B, Chunk<O>, B> f) {
    IO<B> go(Pull<O, Unit> currentPull, B currentAcc) {
      return stepPull(currentPull).flatMap((step) {
        if (step is _StepDone) return IO.pure(currentAcc);
        if (step is _StepOut<O, Unit>) {
          final newAcc = f(currentAcc, step.head);
          return go(step.next, newAcc);
        }
        return IO.raiseError('Invalid compilation state');
      });
    }

    return go(_pull, init);
  }

  IO<Option<O>> get last => foldChunks(none(), (acc, chunk) => chunk.lastOption.orElse(() => acc));

  IO<O> get lastOrError => last.flatMap(
    (opt) => opt.fold(
      () => IO.raiseError('Rill.compile.last: no element'),
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

  IO<IList<O>> get toList => foldChunks(IList.empty<O>(), (acc, chunk) => acc.concat(chunk));

  IO<IVector<O>> get toVector => foldChunks(IVector.empty<O>(), (acc, chunk) => acc.concat(chunk));
}

extension RillCompilerStringOps on RillCompile<String> {
  IO<String> get string => foldChunks(
    StringBuffer(),
    (buf, chunk) => buf..writeAll(chunk.toList()),
  ).map((buf) => buf.toString());
}
