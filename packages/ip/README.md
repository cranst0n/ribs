# ribs_ip

`ribs_ip` is a type-safe, functional library for working with network addresses in Dart. It provides robust representations for IP addresses (IPv4 and IPv6), Hostnames, Ports, and CIDR network ranges.

Designed for the `ribs` ecosystem, it leverages `Option` for safer parsing and `IO` for side-effecting operations like DNS resolution.

## Features

- **Type-Safe IP Addresses**: Distinguished types for `Ipv4Address`, `Ipv6Address`, and their common base `IpAddress`.
- **Hostname Support**: Validation and normalization of hostnames (including IDN/Punycode support).
- **Network Ranges**: CIDR notation support (`192.168.1.0/24`) with methods for contains checks, masking, and finding the first/last address in a range.
- **DNS Operations**: Resolve hostnames to IP addresses and perform reverse lookups.
- **Port Management**: Validated `Port` type (0-65535).
- **Socket Addresses**: Combine a `Host` and `Port` into a `SocketAddress`.
- **Multicast & MAC**: Support for multicast addresses and MAC addresses.

## Why ribs_ip?

1. **Avoid String-ly Typed Code**: Stop passing IP addresses and ports as strings. Let the compiler help you.
2. **Unified API**: Work with IPv4 and IPv6 using a consistent interface.
3. **Safety**: Failures during parsing are represented in the type system (e.g. `None`).
4. **Functional Integration**: Built to work seamlessly within the larger `ribs` ecosystem.

## Quick Examples

### Parsing IP Addresses

```dart
final addressOpt = IpAddress.fromString('192.168.1.1');
  // Returns Option<IpAddress> (specifically Some<Ipv4Address>)

addressOpt.map(
  (addr) => addr.fold(
    (v4) => print('V4: ${v4.toBytes()}'),
    (v6) => print('V6: ${v6.toBytes()}'),
  ),
);
```

### CIDR Network Checks

```dart
(
  Cidr.fromString('192.168.1.0/24'),
  Ipv4Address.fromString('192.168.1.50')
).mapN((cidr, ip) {
  if (cidr.contains(ip)) {
    print('$ip is in $cidr');
  }
});
```

### DNS Resolution

```dart
final program = IO.fromOption(Hostname.fromString('google.com'), () => 'Invalid hostname')
  .flatMap(Dns.resolve)
  .flatMap((ips) => IO.exec(() => ips.foreach(print)));

program.unsafeRunFuture();
```