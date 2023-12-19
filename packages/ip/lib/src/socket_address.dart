import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_ip/ribs_ip.dart';

final class SocketAddress<A extends Host> {
  final A host;
  final Port port;

  const SocketAddress(this.host, this.port);

  static Option<SocketAddress<Host>> fromString(String value) =>
      fromStringIp(value)
          // ignore: unnecessary_cast
          .map((a) => a as SocketAddress<Host>)
          .orElse(
            () =>
                // ignore: unnecessary_cast
                fromStringHostname(value).map((a) => a as SocketAddress<Host>),
          )
          .orElse(
            // ignore: unnecessary_cast
            () => fromStringIDN(value).map((a) => a as SocketAddress<Host>),
          );

  static Option<SocketAddress<IpAddress>> fromStringIp(String value) =>
      fromStringIp4(value)
          // ignore: unnecessary_cast
          .map((a) => a as SocketAddress<IpAddress>)
          .orElse(() => fromStringIp6(value));

  static Option<SocketAddress<Ipv4Address>> fromStringIp4(String value) =>
      _stringMatch(value, _unescapedPattern).flatMapN((hostStr, portStr) => (
            Ipv4Address.fromString(hostStr),
            Port.fromString(portStr)
          ).mapN(SocketAddress.new));

  static Option<SocketAddress<Ipv6Address>> fromStringIp6(String value) =>
      _stringMatch(value, _v6Pattern).flatMapN((hostStr, portStr) => (
            Ipv6Address.fromString(hostStr),
            Port.fromString(portStr)
          ).mapN(SocketAddress.new));

  static Option<SocketAddress<Hostname>> fromStringHostname(String value) =>
      _stringMatch(value, _unescapedPattern).flatMapN((hostStr, portStr) => (
            Hostname.fromString(hostStr),
            Port.fromString(portStr)
          ).mapN(SocketAddress.new));

  static Option<SocketAddress<IDN>> fromStringIDN(String value) =>
      _stringMatch(value, _unescapedPattern).flatMapN((hostStr, portStr) => (
            IDN.fromString(hostStr),
            Port.fromString(portStr)
          ).mapN(SocketAddress.new));

  static final _unescapedPattern = RegExp(r'([^:]+):(\d+)');
  static final _v6Pattern = RegExp(r'\[(.+)\]:(\d+)');

  static Option<(String, String)> _stringMatch(String value, RegExp regex) =>
      Option(regex.firstMatch(value)).filter((a) => a.groupCount == 2).flatMap(
          (match) => Option(match.group(1)).flatMap(
              (host) => Option(match.group(2)).map((port) => (host, port))));

  @override
  String toString() => switch (host) {
        final Ipv6Address _ => '[$host]:$port',
        _ => '$host:$port',
      };

  @override
  bool operator ==(Object that) => switch (that) {
        final SocketAddress that => host == that.host && port == that.port,
        _ => false,
      };

  @override
  int get hashCode => Object.hashAll([host, port]);
}
