import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_ip/ribs_ip.dart';

sealed class Multicast<A extends IpAddress> {
  final A address;

  const Multicast._(this.address);

  static Option<Multicast<A>> fromIpAddress<A extends IpAddress>(A address) {
    if (address.isSourceSpecificMulticast) {
      return Some(_DefaultSourceSpecificMulticast._(address));
    } else if (address.isMulticast) {
      return Some(_DefaultMulticast._(address));
    } else {
      return none();
    }
  }

  // @override
  // String toString() => address.toString();

  // @override
  // bool operator ==(Object that) => switch (that) {
  //       final Multicast that => address == that.address,
  //       _ => false,
  //     };

  // @override
  // int get hashCode => address.hashCode;
}

sealed class SourceSpecificMulticast<A extends IpAddress> extends Multicast<A> {
  const SourceSpecificMulticast._(super.address) : super._();

  Option<SourceSpecificMulticastStrict> strict() =>
      Option.when(() => address.isSourceSpecificMulticast, () => _unsafeCreateStrict(address));

  static Option<SourceSpecificMulticastStrict<A>> fromIpAddress<A extends IpAddress>(
    A address,
  ) => Option.when(
    () => address.isSourceSpecificMulticast,
    () => _DefaultSourceSpecificMulticastStrict._(address),
  );

  static Option<SourceSpecificMulticast<A>> fromIpAddressLenient<A extends IpAddress>(A address) =>
      Option.when(() => address.isMulticast, () => _unsafeCreate(address));

  static SourceSpecificMulticast<A> _unsafeCreate<A extends IpAddress>(A address) =>
      _DefaultSourceSpecificMulticast._(address);

  static SourceSpecificMulticastStrict<A> _unsafeCreateStrict<A extends IpAddress>(A address) =>
      _DefaultSourceSpecificMulticastStrict._(address);
}

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
