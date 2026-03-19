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

final class Dns {
  static final _platformImpl = DnsPlatform();

  static IO<IList<IpAddress>> loopback() => _platformImpl.loopback();

  static IO<IList<IpAddress>> resolve(Hostname hostname) => _platformImpl.resolve(hostname);

  static IO<Hostname> reverse(IpAddress address) => _platformImpl.reverse(address);

  static IO<Option<Hostname>> reverseOption(IpAddress address) =>
      _platformImpl.reverseOption(address);
}
