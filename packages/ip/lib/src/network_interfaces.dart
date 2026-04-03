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
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_ip/src/network_interfaces_platform/network_interfaces_platform.dart';

/// Provides access to the host's network interfaces.
///
/// This is a singleton — all calls share the same platform implementation.
final class NetworkInterfaces {
  static final _platformImpl = NetworkInterfacesPlatform();

  static const _instance = NetworkInterfaces._();

  factory NetworkInterfaces() => _instance;

  const NetworkInterfaces._();

  /// Returns all network interfaces on the host, keyed by interface name.
  IO<IMap<String, NetworkInterface>> getAll() => _platformImpl.getAll();

  /// Returns the first interface whose CIDR addresses contain [address],
  /// or [None] if no matching interface is found.
  IO<Option<NetworkInterface>> getByAddress(IpAddress address) => getAll().map(
    (all) => all.values.collectFirst(
      (iface) => Option.when(
        () => iface.addresses.exists((addr) => addr.address == address),
        () => iface,
      ),
    ),
  );

  /// Returns the interface with the given [name], or [None] if not found.
  IO<Option<NetworkInterface>> getByName(String name) => getAll().map((all) => all.get(name));

  /// Returns the loopback IP addresses for the current host.
  IO<IList<IpAddress>> loopback() => _platformImpl.loopback();
}
