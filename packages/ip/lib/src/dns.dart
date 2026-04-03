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
import 'package:ribs_ip/src/dns_platform/dns_platform.dart';
import 'package:ribs_ip/src/host.dart';

/// Static facade for DNS operations, delegating to the platform implementation.
final class Dns {
  static final _platformImpl = DnsPlatform();

  /// Resolves loopback addresses for the current host.
  static IO<IList<IpAddress>> loopback() => _platformImpl.loopback();

  /// Resolves [hostname] to a list of [IpAddress] values via DNS lookup.
  static IO<IList<IpAddress>> resolve(Hostname hostname) => _platformImpl.resolve(hostname);

  /// Performs a reverse DNS lookup for [address], returning the associated
  /// [Hostname]. Fails the [IO] if no PTR record is found.
  static IO<Hostname> reverse(IpAddress address) => _platformImpl.reverse(address);

  /// Performs a reverse DNS lookup for [address], returning [Some] hostname
  /// if a PTR record exists or [None] if not found.
  static IO<Option<Hostname>> reverseOption(IpAddress address) =>
      _platformImpl.reverseOption(address);
}
