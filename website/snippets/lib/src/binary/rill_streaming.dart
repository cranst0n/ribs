// ignore_for_file: unused_local_variable

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';

// Event model (same as streaming.dart; not shown in docs)
final class Event {
  final DateTime timestamp;
  final int id;
  final String message;

  const Event(this.timestamp, this.id, this.message);

  static final codec = Codec.product3(
    Codec.int64.xmap(
      (i) => DateTime.fromMillisecondsSinceEpoch(i),
      (date) => date.millisecondsSinceEpoch,
    ),
    Codec.uint24,
    Codec.utf8_32,
    Event.new,
    (evt) => (evt.timestamp, evt.id, evt.message),
  );
}

// #region streaming-rill-encode
IO<Unit> sendEvents(Rill<Event> events, SocketAddress addr) => Network.connect(addr).use(
  (socket) =>
      events
          // Encode each Event to bytes using the codec
          .through(RillEncoder.many(Event.codec).toPipeByte)
          // Write the byte stream to the socket
          .through(socket.writes)
          .compile
          .drain,
);
// #endregion streaming-rill-encode

IO<Unit> processEvent(Event _) => IO.unit;

// #region streaming-rill-decode
// Decode incoming bytes from a single client connection
IO<Unit> handleClient(Socket socket) =>
    socket.reads
        // Reassemble framed Events from the raw byte stream
        .through(RillDecoder.many(Event.codec).toPipeByte)
        // Process each decoded Event
        .foreach(processEvent)
        .compile
        .drain;

// Accept clients and handle each one sequentially
IO<Unit> runServer(SocketAddress addr) =>
    Network.bindAndAccept(addr).evalMap(handleClient).compile.drain;
// #endregion streaming-rill-decode

// A simple protocol header: 1-byte version followed by a stream of Events.
final class Header {
  final int version;
  const Header(this.version);

  static final codec = Codec.uint8.xmap(Header.new, (h) => h.version);
}

// #region streaming-rill-header-encode
IO<Unit> sendEventsWithHeader(
  Header header,
  Rill<Event> events,
  SocketAddress addr,
) => Network.connect(addr).use(
  (socket) =>
      // RillEncoder.once sends the header exactly once, then the events follow
      (Rill.emit(header).through(RillEncoder.once(Header.codec).toPipeByte) +
              events.through(RillEncoder.many(Event.codec).toPipeByte))
          .through(socket.writes)
          .compile
          .drain,
);
// #endregion streaming-rill-header-encode

// #region streaming-rill-header-decode
// RillDecoder.once reads the header, flatMap hands the remainder to many(Event.codec)
final headerThenEvents = RillDecoder.once(
  Header.codec,
).flatMap((_) => RillDecoder.many(Event.codec));

IO<Unit> handleClientWithHeader(Socket socket) =>
    socket.reads.through(headerThenEvents.toPipeByte).foreach(processEvent).compile.drain;
// #endregion streaming-rill-header-decode
