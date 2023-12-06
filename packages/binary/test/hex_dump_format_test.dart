import 'package:ribs_binary/ribs_binary.dart';
import 'package:test/test.dart';

void main() {
  group('HexDumpFormat', () {
    test('golden', () {
      final actual = ByteVector.fromValidHex('deadbeef' * 16).toHexDump();
      const expected = '''
00000000  de ad be ef de ad be ef  de ad be ef de ad be ef  |................|
00000010  de ad be ef de ad be ef  de ad be ef de ad be ef  |................|
00000020  de ad be ef de ad be ef  de ad be ef de ad be ef  |................|
00000030  de ad be ef de ad be ef  de ad be ef de ad be ef  |................|
''';

      expect(actual, expected);
    });
  });
}
