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
import 'package:ribs_ip/ribs_ip.dart';

/// A typed wrapper around a multicast [IpAddress].
///
/// Use [fromIpAddress] to construct; returns [None] if the address is not
/// in the multicast range. Source-specific multicast addresses are
/// represented by the [SourceSpecificMulticast] subtype.
sealed class Multicast<A extends IpAddress> {
  /// The underlying multicast IP address.
  final A address;

  const Multicast._(this.address);

  /// Returns a [Multicast] for [address] if it is a multicast address,
  /// otherwise returns [None].
  ///
  /// If the address is source-specific multicast, the returned value will
  /// be a [SourceSpecificMulticast].
  static Option<Multicast<A>> fromIpAddress<A extends IpAddress>(A address) {
    if (address.isSourceSpecificMulticast) {
      return Some(_DefaultSourceSpecificMulticast._(address));
    } else if (address.isMulticast) {
      return Some(_DefaultMulticast._(address));
    } else {
      return none();
    }
  }
}

/// A [Multicast] address that falls within the source-specific multicast (SSM)
/// range, or any multicast address when constructed leniently.
///
/// Use [fromIpAddress] for strict SSM construction (requires the address to be
/// within the SSM range) or [fromIpAddressLenient] to accept any multicast
/// address.
sealed class SourceSpecificMulticast<A extends IpAddress> extends Multicast<A> {
  const SourceSpecificMulticast._(super.address) : super._();

  /// Returns a [SourceSpecificMulticastStrict] if this address is in the
  /// strict SSM range, otherwise [None].
  Option<SourceSpecificMulticastStrict> strict() =>
      Option.when(() => address.isSourceSpecificMulticast, () => _unsafeCreateStrict(address));

  /// Returns a [SourceSpecificMulticastStrict] for [address] if it is in the
  /// source-specific multicast range, otherwise [None].
  static Option<SourceSpecificMulticastStrict<A>> fromIpAddress<A extends IpAddress>(
    A address,
  ) => Option.when(
    () => address.isSourceSpecificMulticast,
    () => _DefaultSourceSpecificMulticastStrict._(address),
  );

  /// Returns a [SourceSpecificMulticast] for [address] if it is any multicast
  /// address (not limited to the strict SSM range), otherwise [None].
  static Option<SourceSpecificMulticast<A>> fromIpAddressLenient<A extends IpAddress>(A address) =>
      Option.when(() => address.isMulticast, () => _unsafeCreate(address));

  static SourceSpecificMulticast<A> _unsafeCreate<A extends IpAddress>(A address) =>
      _DefaultSourceSpecificMulticast._(address);

  static SourceSpecificMulticastStrict<A> _unsafeCreateStrict<A extends IpAddress>(A address) =>
      _DefaultSourceSpecificMulticastStrict._(address);
}

/// A [SourceSpecificMulticast] whose address has been verified to be within
/// the strict source-specific multicast range.
sealed class SourceSpecificMulticastStrict<A extends IpAddress> extends Multicast<A> {
  const SourceSpecificMulticastStrict._(super.address) : super._();
}

class _DefaultMulticast<A extends IpAddress> extends Multicast<A> {
  const _DefaultMulticast._(super.address) : super._();

  @override
  String toString() => address.toString();

  @override
  bool operator ==(Object that) => switch (that) {
    final Multicast<A> that => address == that.address,
    _ => false,
  };

  @override
  int get hashCode => address.hashCode;
}

class _DefaultSourceSpecificMulticast<A extends IpAddress> extends SourceSpecificMulticast<A> {
  const _DefaultSourceSpecificMulticast._(super.address) : super._();

  @override
  String toString() => address.toString();

  @override
  bool operator ==(Object that) => switch (that) {
    final SourceSpecificMulticast<A> that => address == that.address,
    _ => false,
  };

  @override
  int get hashCode => address.hashCode;
}

class _DefaultSourceSpecificMulticastStrict<A extends IpAddress>
    extends SourceSpecificMulticastStrict<A> {
  const _DefaultSourceSpecificMulticastStrict._(super.address) : super._();

  @override
  String toString() => address.toString();

  @override
  bool operator ==(Object that) => switch (that) {
    final SourceSpecificMulticastStrict<A> that => address == that.address,
    _ => false,
  };

  @override
  int get hashCode => address.hashCode;
}
