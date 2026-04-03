import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/src/io_platform/io_platform_stub.dart';

/// Platform-specific operations for [IO].
///
/// This abstraction allows [IO] to use different implementations depending
/// on whether it's running on the Dart VM (e.g., using Isolates) or on the
/// web (where Isolates and file I/O are not available).
abstract class IOPlatform {
  /// Returns the appropriate [IOPlatform] implementation for the current
  /// platform.
  factory IOPlatform() => IOPlatformImpl();

  /// Runs [io] in a separate execution context (e.g., an Isolate on the Dart VM)
  /// and returns its result asynchronously.
  IO<A> isolate<A>(IO<A> io, {String? debugName});

  /// Prints [message] to the standard output of the current platform.
  IO<Unit> print(String message);

  /// Reads a line from the standard input of the current platform.
  ///
  /// **Note:** This is a blocking operation and will not finish until a full
  /// line of input is available.
  IO<String> readLine();

  /// Installs a signal handler (e.g., SIGUSR1 on POSIX) that triggers a fiber
  /// dump when received, if supported by the platform.
  void installFiberDumpSignalHandler();
}
