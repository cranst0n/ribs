// This file is derived in part from ip4s.
// https://github.com/Comcast/ip4s
//
// ip4s (https://github.com/Comcast/ip4s)
//
// Copyright 2018 Comcast Cable Communications Management, LLC
//
// Licensed under Apache License 2.0
// (http://www.apache.org/licenses/LICENSE-2.0).
//
// See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.

import 'package:ribs_core/ribs_core.dart';

final class Port extends Ordered<Port> {
  static const MinValue = 0;
  static const MaxValue = 65535;

  static const Wildcard = Port._(0);

  final int value;

  const Port._(this.value);

  static Option<Port> fromInt(int value) =>
      Option.when(() => MinValue <= value && value <= MaxValue, () => Port._(value));

  static Option<Port> fromString(String value) => Option(int.tryParse(value)).flatMap(fromInt);

  @override
  int compareTo(Port other) => value.compareTo(other.value);

  @override
  bool operator ==(Object that) => switch (that) {
    final Port that => value == that.value,
    _ => false,
  };

  @override
  int get hashCode => Object.hashAll([value, 'Port'.hashCode]);

  @override
  String toString() => value.toString();
}
