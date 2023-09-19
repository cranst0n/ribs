// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:ribs_binary/ribs_binary.dart';

/// streaming-1

final class Event {
  final DateTime timestamp;
  final int id;
  final String message;

  const Event(this.timestamp, this.id, this.message);

  static final codec = Codec.product3(
    int64.xmap(
      (i) => DateTime.fromMillisecondsSinceEpoch(i),
      (date) => date.millisecondsSinceEpoch,
    ),
    uint24,
    utf8_32,
    Event.new,
    (evt) => (evt.timestamp, evt.id, evt.message),
  );
}

/// streaming-1

Future<void> snippet2() async {
  /// streaming-2

  Stream<Event> events() => throw UnimplementedError('TODO');

  final socket = await Socket.connect('localhost', 12345);

  final Future<void> eventWriter = events()
      // Encodes each Event to BitVector
      .transform(StreamEncoder(Event.codec))
      // Convert BitVector to Uint8List
      .map((bitVector) => bitVector.toByteArray())
      // Write each Uint8List to Socket
      .forEach((byteList) => socket.add(byteList));

  /// streaming-2
}

Future<void> snippet3() async {
  /// streaming-3
  void storeEvent(Event evt) => throw UnimplementedError('TODO');

  Future<void> handleClient(Socket clientSocket) => clientSocket
      // Convert Uint8List to BitVector
      .map((bytes) => ByteVector(bytes).bits)
      // Convert BitVector to Event
      .transform(StreamDecoder(Event.codec))
      // Do something with the events
      .forEach(storeEvent);

  final socket = await ServerSocket.bind('0.0.0.0', 12345);
  final events = socket.forEach(handleClient);

  /// streaming-3
}
