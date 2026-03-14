import 'dart:async';

import 'package:ribs_core/ribs_core.dart';

abstract class IORuntime {
  static const DefaultAutoCedeN = 512;

  final int autoCedeN;

  IORuntime({this.autoCedeN = DefaultAutoCedeN}) {
    if (autoCedeN < 1) throw ArgumentError('IORuntime.autoCedeN must be > 0');
  }

  DateTime get now;

  void schedule(Function0<void> task);

  Function0<void> scheduleAfter(Duration delay, Function0<void> onWake);

  static final IORuntime defaultRuntime = RealIORuntime();
}

class RealIORuntime extends IORuntime {
  RealIORuntime({super.autoCedeN});

  @override
  DateTime get now => DateTime.now();

  @override
  void schedule(Function0<void> task) => Timer.run(task);

  @override
  Function0<void> scheduleAfter(Duration delay, Function0<void> onWake) {
    final t = Timer(delay, onWake);

    return () => t.cancel();
  }
}
