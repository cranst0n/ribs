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

/// A TCP or UDP port number in the range [MinValue, MaxValue] (0–65535).
final class Port extends Ordered<Port> {
  /// The minimum valid port number (0).
  static const MinValue = 0;

  /// The maximum valid port number (65535).
  static const MaxValue = 65535;

  /// The wildcard port (0), used to indicate any available port.
  static const Wildcard = Port._(0);

  /// The numeric port value.
  final int value;

  const Port._(this.value);

  /// Returns a [Port] for [value] if it is in [MinValue]..[MaxValue],
  /// otherwise returns [None].
  static Option<Port> fromInt(int value) =>
      Option.when(() => MinValue <= value && value <= MaxValue, () => Port._(value));

  /// Parses [value] as a decimal integer and returns a [Port] if valid,
  /// otherwise returns [None].
  static Option<Port> fromString(String value) => Option(int.tryParse(value)).flatMap(fromInt);

  @override
  int compareTo(Port other) => value.compareTo(other.value);

  @override
  bool operator ==(Object other) => switch (other) {
    final Port that => value == that.value,
    _ => false,
  };

  @override
  int get hashCode => Object.hashAll([value, 'Port'.hashCode]);

  /// Returns the port number as a decimal string.
  @override
  String toString() => value.toString();
}
