/// Test utilities and matchers for `ribs_effect`.
///
/// Provides a deterministic [TestIORuntime] for precise control over time in
/// tests, along with matchers like [succeeds], [errors], and [cancels] for
/// asserting on [IO] program outcomes.
library;

export 'src/io.dart';
export 'src/io_runtime.dart';
