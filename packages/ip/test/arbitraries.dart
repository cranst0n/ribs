import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_ip/ribs_ip.dart';

final genIp = Gen.oneOfGen([genIpv4, genIpv6]);
final genIpv4 = Gen.byte.tuple4.map(Ipv4Address.fromBytes.tupled);
final genIpv6 = Gen.byte.tuple16.map(Ipv6Address.fromBytes.tupled);

final genMulticast4 = genIpv4.map((ip) {
  final i = ip.toInt() & ~(15 << 28) | (14 << 28);
  return Ipv4Address.fromInt(i)
      .asMulticast()
      .getOrElse(() => throw Exception('genMulticast4 failed: $ip'));
});

final genHostname = _genHostnameImpl();
final genIDN = _genIdnImpl();

final genMacAddress = Gen.listOfN(6, Gen.byte).map((bytes) =>
    MacAddress.fromByteList(bytes)
        .getOrElse(() => throw Exception('genMacAddress failed: $bytes')));

final genPort = Gen.chooseInt(Port.MinValue, Port.MaxValue).map((i) =>
    Port.fromInt(i).getOrElse(() => throw Exception('genPort failed: $i')));

final genSocketAddress = (Gen.oneOfGen([genIp, genHostname]), genPort)
    .tupled
    .map((tup) => SocketAddress<Host>(tup.$1, tup.$2));

Gen<Cidr<A>> genCidr<A extends IpAddress>(Gen<A> genIp) =>
    genIp.flatMap((ip) => Gen.chooseInt(0, ip.fold((_) => 32, (_) => 128))
        .map((prefixBits) => Cidr.of(ip, prefixBits)));

Gen<Hostname> _genHostnameImpl() {
  final genLabel = Gen.alphaNumChar.flatMap((first) {
    return Gen.chooseInt(0, 61).flatMap((middleLen) {
      return Gen.ilistOfN(
              middleLen, Gen.oneOfGen([Gen.alphaNumChar, Gen.constant('-')]))
          .map((a) => a.mkString())
          .flatMap((middle) {
        return (middleLen > 0
                ? Gen.some(Gen.alphaNumChar)
                : Gen.option(Gen.alphaNumChar))
            .map((s) => s.getOrElse(() => ""))
            .map((last) => '$first$middle$last');
      });
    });
  });

  return Gen.chooseInt(1, 5).flatMap((numLabels) {
    return Gen.ilistOfN(numLabels, genLabel)
        .retryUntil((a) =>
            a.foldLeft(0, (a, b) => a + b.length) < (253 - numLabels - 1))
        .map((labels) {
      return Hostname.fromString(labels.mkString(sep: '.'))
          .getOrElse(() => throw Exception('genHostname failed: $labels'));
    });
  });
}

Gen<IDN> _genIdnImpl() {
  final genChar = Gen.oneOfGen([Gen.alphaNumChar, Gen.charSample('δπθ')]);
  final genLabel = genChar.flatMap((first) {
    return Gen.chooseInt(0, 61).flatMap((middleLen) {
      return Gen.ilistOfN(middleLen, Gen.oneOfGen([genChar, Gen.constant('-')]))
          .map((a) => a.mkString())
          .flatMap((middle) {
        return (middleLen > 0
                ? Gen.some(Gen.alphaNumChar)
                : Gen.option(Gen.alphaNumChar))
            .map((s) => s.getOrElse(() => ""))
            .map((last) => '$first$middle$last')
            .retryUntil((str) => IDN.toAscii(str).isDefined);
      });
    });
  });

  return Gen.chooseInt(1, 5)
      .flatMap((numLabels) {
        return Gen.ilistOfN(numLabels, genLabel).flatMap((labels) {
          return Gen.oneOf(['.', '\u002e', '\u3002', '\uff0e', '\uff61'])
              .map((dot) {
            return IDN.fromString(labels.mkString(sep: dot));
          });
        });
      })
      .retryUntil((a) => a.isDefined)
      .map(
          (idnOpt) => idnOpt.getOrElse(() => throw Exception('genIdn failed')));
}
