part of '../parser.dart';

final class Index extends Parser0<int> {
  @override
  int? _parseMut(State state) => state.offset;
}
