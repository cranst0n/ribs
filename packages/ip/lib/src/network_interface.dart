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

/// A network interface — a named hardware or virtual adapter with one or more
/// IP addresses expressed as CIDR blocks.
abstract class NetworkInterface {
  /// The operating-system name of this interface (e.g. `"eth0"`, `"lo"`).
  String get name;

  /// The IP addresses assigned to this interface, each paired with its subnet
  /// prefix length as a [Cidr].
  IList<Cidr<IpAddress>> get addresses;
}
