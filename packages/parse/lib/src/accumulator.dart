import 'package:ribs_core/ribs_core.dart';

/// A zero-or-more accumulator: builds a result [B] from zero or more items of
/// type [A].
///
/// Extends [Accumulator] with an optional first element so that it can be used
/// with `rep0`-style parsers, where the parse may succeed without consuming any
/// input.
abstract class Accumulator0<A, B> extends Accumulator<A, B> {
  @override
  Appender<A, B> newAppender([A? first]);

  /// An [Accumulator0] that collects items into an [IList].
  static Accumulator0<A, IList<A>> ilist<A>() => IListAcc0();

  /// An [Accumulator0] that concatenates [String] items into a single [String].
  static Accumulator0<String, String> string() => StringAcc0();

  /// An [Accumulator0] that discards all items and returns [Unit].
  static final Accumulator0<dynamic, Unit> unit = UnitAccumulator0();
}

final class IListAcc0<A> extends Accumulator0<A, IList<A>> {
  @override
  Appender<A, IList<A>> newAppender([A? first]) {
    final appender = Appender.ilist<A>();
    if (first != null) appender.append(first);
    return appender;
  }
}

final class StringAcc0 extends Accumulator0<String, String> {
  @override
  Appender<String, String> newAppender([String? first]) {
    final appender = Appender.string();
    if (first != null) appender.append(first);
    return appender;
  }
}

final class UnitAccumulator0 extends Accumulator0<dynamic, Unit> {
  UnitAccumulator0();

  @override
  Appender<dynamic, Unit> newAppender([dynamic first]) => UnitAppender();
}

/// A one-or-more accumulator: builds a result [B] from one or more items of
/// type [A].
///
/// Used with `rep`-style parsers where at least one item must be present.
/// The first item is always passed to [newAppender]; subsequent items are
/// added via [Appender.append].
abstract class Accumulator<A, B> {
  /// Creates a new [Appender] seeded with [first].
  Appender<A, B> newAppender(A first);

  /// An [Accumulator] that collects items into a [NonEmptyIList].
  static Accumulator<A, NonEmptyIList<A>> nel<A>() => NelAcc();

  /// An [Accumulator] that concatenates [String] items into a single [String].
  static Accumulator<String, String> string() => StringAcc();

  /// An [Accumulator] that discards all items and returns [Unit].
  static final Accumulator<dynamic, Unit> unit = UnitAccumulator();
}

final class NelAcc<A> extends Accumulator<A, NonEmptyIList<A>> {
  @override
  Appender<A, NonEmptyIList<A>> newAppender(A first) {
    return Appender.nel(first);
  }
}

final class StringAcc extends Accumulator<String, String> {
  @override
  Appender<String, String> newAppender(String first) => Appender.string()..append(first);
}

final class UnitAccumulator extends Accumulator<dynamic, Unit> {
  UnitAccumulator();

  @override
  Appender<dynamic, Unit> newAppender(dynamic first) => UnitAppender();
}

/// A mutable builder that accumulates items of type [A] and produces a result
/// of type [B] via [finish].
abstract class Appender<A, B> {
  /// Appends [item] to this builder and returns `this` for chaining.
  Appender<A, B> append(A item);

  /// Finalises the builder and returns the accumulated result.
  B finish();

  /// An [Appender] that collects items into an [IList].
  static Appender<A, IList<A>> ilist<A>() => IListAppender();

  /// An [Appender] that collects items into a [NonEmptyIList] seeded with [first].
  static Appender<A, NonEmptyIList<A>> nel<A>(A first) => NelAppender(first);

  /// An [Appender] that concatenates [String] items into a single [String].
  static Appender<String, String> string() => StringAppender();

  /// An [Appender] that discards all items and returns [Unit].
  static Appender<dynamic, Unit> unit() => UnitAppender();
}

final class IListAppender<A> extends Appender<A, IList<A>> {
  final bldr = IList.builder<A>();

  @override
  Appender<A, IList<A>> append(A item) {
    bldr.addOne(item);
    return this;
  }

  @override
  IList<A> finish() => bldr.toIList();
}

final class NelAppender<A> extends Appender<A, NonEmptyIList<A>> {
  final A head;
  final tail = IList.builder<A>();

  NelAppender(this.head);

  @override
  Appender<A, NonEmptyIList<A>> append(A item) {
    tail.addOne(item);
    return this;
  }

  @override
  NonEmptyIList<A> finish() => NonEmptyIList(head, tail.toIList());
}

final class StringAppender extends Appender<String, String> {
  final StringBuffer buffer = StringBuffer();

  @override
  Appender<String, String> append(String item) {
    buffer.write(item);
    return this;
  }

  @override
  String finish() => buffer.toString();
}

final class UnitAppender extends Appender<dynamic, Unit> {
  @override
  Appender<dynamic, Unit> append(dynamic item) => this;

  @override
  Unit finish() => Unit();
}
