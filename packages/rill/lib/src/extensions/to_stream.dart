import 'dart:async';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

extension ToDartStreamOps<O> on Rill<O> {
  Stream<O> toDartStream() {
    late StreamController<O> controller;
    IOFiber<Unit>? activeFiber;

    controller = StreamController(
      onListen: () {
        final program = evalMap(
              (o) => IO.exec(() {
                if (!controller.isClosed) controller.add(o);
              }),
            )
            .handleErrorWith((err) {
              return Rill.eval(
                IO.exec(() {
                  if (!controller.isClosed) controller.addError(err);
                }),
              );
            })
            .compile
            .drain
            .guarantee(
              IO.exec(() {
                if (!controller.isClosed) controller.close();
              }),
            );

        final startIO = program.start();

        startIO.unsafeRunAsync((outcome) {
          outcome.fold(
            () {
              if (!controller.isClosed) controller.close();
            },
            (err, stackTrace) {
              if (!controller.isClosed) controller.addError(err, stackTrace);
            },
            (fiber) => activeFiber = fiber,
          );
        });
      },
      onCancel: () {
        if (activeFiber != null) {
          final completer = Completer<void>();
          activeFiber!.cancel().unsafeRunAsync((_) => completer.complete());
          return completer.future;
        }
      },
    );

    return controller.stream;
  }
}
