part of '../io.dart';

/// Global configuration for IO fiber tracing.
///
/// When [tracingEnabled] is `true`, the interpreter records a ring buffer
/// of labeled trace entries for each fiber. This is useful for debugging
/// complex async programs but adds overhead and should be disabled in
/// production.
class IOTracingConfig {
  /// Whether tracing is currently enabled. Defaults to `false`.
  static bool tracingEnabled = false;

  /// The maximum number of trace entries retained per fiber.
  static int traceBufferSize = 64;
}

/// A synthetic [StackTrace] composed of [IO.traced] labels collected
/// during fiber execution.
///
/// When an error occurs and tracing is enabled, the fiber attaches an
/// [IOFiberTrace] to the error's stack trace so that the logical call
/// chain through [IO] combinators is visible.
class IOFiberTrace implements StackTrace {
  /// The ordered list of trace labels, from outermost to innermost.
  final List<String> trace;

  IOFiberTrace(this.trace);

  @override
  String toString() => "IOFiberTrace: ${trace.reversed.map((l) => '  $l').join('\n')}";
}

/// Extension providing the [traced] combinator on [IO].
extension IOTracingOps<A> on IO<A> {
  /// Annotates this [IO] with a [label] for tracing purposes.
  ///
  /// When [IOTracingConfig.tracingEnabled] is `true`, the label is recorded
  /// in the fiber's trace ring buffer. When tracing is disabled, this is a
  /// no-op that returns the original [IO] unchanged.
  ///
  /// [depth] optionally limits how many frames of the captured [StackTrace]
  /// are stored.
  IO<A> traced(String label, [int? depth]) {
    if (!IOTracingConfig.tracingEnabled) {
      return this;
    } else {
      return _Traced(this, label, depth);
    }
  }
}

/// A fixed-size ring buffer that stores the most recent trace entries for
/// a fiber, evicting oldest entries when full.
class _TraceRingBuffer {
  final List<(String, String)?> _buffer;
  int _head = 0;
  int _count = 0;

  _TraceRingBuffer(int size) : _buffer = List.filled(size, null);

  void push(String label, String trace) {
    _buffer[_head] = (label, trace);
    _head = (_head + 1) % _buffer.length;

    if (_count < _buffer.length) _count++;
  }

  List<String> toList() {
    final list = <String>[];

    final maxLabelLen = _buffer.nonNulls.fold(0, (len, tuple) => max(len, tuple.$1.length));

    int index = (_count < _buffer.length) ? 0 : _head;

    for (int i = 0; i < _count; i++) {
      if (_buffer[index] case (final label, final trace)) {
        list.add('${label.padLeft(maxLabelLen)} @ $trace');
      }
      index = (index + 1) % _buffer.length;
    }

    return list;
  }
}
