part of '../io.dart';

class IOTracingConfig {
  static bool tracingEnabled = false;
  static int traceBufferSize = 64;
}

class IOFiberTrace implements StackTrace {
  final List<String> trace;

  IOFiberTrace(this.trace);

  @override
  String toString() => "IOFiberTrace: ${trace.reversed.map((l) => '  $l').join('\n')}";
}

extension IOTracingOps<A> on IO<A> {
  IO<A> traced(String label, [int? depth]) {
    if (!IOTracingConfig.tracingEnabled) {
      return this;
    } else {
      return _Traced(this, label, depth);
    }
  }
}

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
