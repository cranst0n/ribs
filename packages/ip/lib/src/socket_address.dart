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

/// A network socket address — a [Host] paired with a [Port].
///
/// The type parameter [A] constrains the host to a specific subtype of [Host],
/// allowing e.g. `SocketAddress<Ipv4Address>` for IPv4-only addresses.
///
/// IPv6 addresses are formatted with brackets: `[::1]:8080`.
/// Other hosts use the plain `host:port` form.
final class SocketAddress<A extends Host> {
  /// The host component of this socket address.
  final A host;

  /// The port component of this socket address.
  final Port port;

  const SocketAddress(this.host, this.port);

  /// The wildcard socket address `0.0.0.0:0`.
  static final Wildcard = SocketAddress(Ipv4Address.Wildcard, Port.Wildcard);

  /// Returns a wildcard host socket address bound to [port].
  static SocketAddress withPort(Port port) => SocketAddress(Ipv4Address.Wildcard, port);

  /// Parses [value] as a socket address with any supported host type
  /// (IP address, hostname, or IDN), returning [None] if parsing fails.
  static Option<SocketAddress<Host>> fromString(String value) => fromStringIp(value)
      .map((a) => a as SocketAddress<Host>) // ignore: unnecessary_cast
      .orElse(
        () => fromStringHostname(
          value,
        ).map((a) => a as SocketAddress<Host>), // ignore: unnecessary_cast
      )
      .orElse(
        () => fromStringIDN(value).map((a) => a as SocketAddress<Host>), // ignore: unnecessary_cast
      );

  /// Parses [value] as a socket address with an [IpAddress] host (IPv4 or
  /// IPv6), returning [None] if parsing fails.
  static Option<SocketAddress<IpAddress>> fromStringIp(String value) => fromStringIp4(value)
      .map((a) => a as SocketAddress<IpAddress>) // ignore: unnecessary_cast
      .orElse(() => fromStringIp6(value));

  /// Parses [value] as an IPv4 socket address in `a.b.c.d:port` form,
  /// returning [None] if parsing fails.
  static Option<SocketAddress<Ipv4Address>> fromStringIp4(String value) =>
      _stringMatch(value, _unescapedPattern).flatMapN(
        (hostStr, portStr) =>
            (Ipv4Address.fromString(hostStr), Port.fromString(portStr)).mapN(SocketAddress.new),
      );

  /// Parses [value] as an IPv6 socket address in `[addr]:port` form,
  /// returning [None] if parsing fails.
  static Option<SocketAddress<Ipv6Address>> fromStringIp6(String value) =>
      _stringMatch(value, _v6Pattern).flatMapN(
        (hostStr, portStr) =>
            (Ipv6Address.fromString(hostStr), Port.fromString(portStr)).mapN(SocketAddress.new),
      );

  /// Parses [value] as a socket address with an ASCII [Hostname] host,
  /// returning [None] if parsing fails.
  static Option<SocketAddress<Hostname>> fromStringHostname(String value) =>
      _stringMatch(value, _unescapedPattern).flatMapN(
        (hostStr, portStr) =>
            (Hostname.fromString(hostStr), Port.fromString(portStr)).mapN(SocketAddress.new),
      );

  /// Parses [value] as a socket address with an [IDN] host,
  /// returning [None] if parsing fails.
  static Option<SocketAddress<IDN>> fromStringIDN(String value) =>
      _stringMatch(value, _unescapedPattern).flatMapN(
        (hostStr, portStr) =>
            (IDN.fromString(hostStr), Port.fromString(portStr)).mapN(SocketAddress.new),
      );

  static final _unescapedPattern = RegExp(r'([^:]+):(\d+)');
  static final _v6Pattern = RegExp(r'\[(.+)\]:(\d+)');

  static Option<(String, String)> _stringMatch(String value, RegExp regex) =>
      Option(regex.firstMatch(value))
          .filter((a) => a.groupCount == 2)
          .flatMap(
            (match) => Option(
              match.group(1),
            ).flatMap((host) => Option(match.group(2)).map((port) => (host, port))),
          );

  /// Returns `[host]:port` for IPv6 hosts, or `host:port` for all others.
  @override
  String toString() => switch (host) {
    final Ipv6Address _ => '[$host]:$port',
    _ => '$host:$port',
  };

  @override
  bool operator ==(Object other) => switch (other) {
    final SocketAddress that => host == that.host && port == that.port,
    _ => false,
  };

  @override
  int get hashCode => Object.hashAll([host, port]);
}
