part of '../parser.dart';

final class Pure<A> extends Parser0<A> {
  final A a;

  Pure(this.a);

  @override
  A? _parseMut(State state) => a;
}
