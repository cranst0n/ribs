import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:test/test.dart';

void main() {
  test('flatMap', () {
    final evenDecoder = Decoder.integer.flatMap(
        (i) => i.isEven ? Decoder.constant(i) : Decoder.constant(i * 2));

    expect(evenDecoder.decode(Json.number(2)), 2.asRight<DecodingFailure>());
    expect(evenDecoder.decode(Json.number(3)), 6.asRight<DecodingFailure>());
  });

  test('handleError', () {
    final d = Decoder.instance<int>(
            (c) => DecodingFailure(CustomReason('boom'), c.history()).asLeft())
        .handleErrorWith((_) => Decoder.constant(42));

    expect(d.decode(Json.False), 42.asRight<DecodingFailure>());
    expect(d.decode(Json.Null), 42.asRight<DecodingFailure>());
    expect(d.decode(Json.str('boo')), 42.asRight<DecodingFailure>());
    expect(d.decode(Json.number(1)), 42.asRight<DecodingFailure>());
  });

  test('list', () {
    final d = Decoder.list(Decoder.integer);

    expect(
      d.decode(Json.arr([Json.number(0)])).map((a) => a.toIList()),
      ilist([0]).asRight<DecodingFailure>(),
    );

    expect(
      d.decode(Json.True),
      isLeft<DecodingFailure, List<int>>(),
    );
  });

  test('prepared', () {
    final d = Decoder.integer.prepare((a) => a.downField('key'));
    final json = Json.obj([('key', Json.number(42))]);

    expect(d.decode(json), 42.asRight<DecodingFailure>());
  });
}
