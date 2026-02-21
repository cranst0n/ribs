import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_rill/ribs_rill.dart';

abstract class DatagramSocket {
  SocketAddress get address;

  IO<Unit> disconnect();

  IO<Datagram> read();

  Rill<Datagram> get reads;

  IO<Unit> write(Datagram datagram);

  Pipe<Datagram, Never> get writes;
}

final class Datagram {
  final SocketAddress remote;
  final Chunk<int> bytes;

  const Datagram(this.remote, this.bytes);
}
