import 'package:ribs_units/ribs_units.dart';
import 'package:test/test.dart';

void main() {
  group('Quantity', () {
    group('comparison operators', () {
      test('operator >', () {
        expect(2.0.meters > 1.0.meters, isTrue);
        expect(1.0.meters > 2.0.meters, isFalse);
        // cross-unit: 1 km > 500 m
        expect(1.0.kilometers > 500.0.meters, isTrue);
        expect(500.0.meters > 1.0.kilometers, isFalse);
      });

      test('operator <', () {
        expect(1.0.meters < 2.0.meters, isTrue);
        expect(2.0.meters < 1.0.meters, isFalse);
        // cross-unit: 500 m < 1 km
        expect(500.0.meters < 1.0.kilometers, isTrue);
        expect(1.0.kilometers < 500.0.meters, isFalse);
      });

      test('operator >=', () {
        expect(2.0.meters >= 2.0.meters, isTrue);
        expect(2.0.meters >= 1.0.meters, isTrue);
        expect(1.0.meters >= 2.0.meters, isFalse);
        // cross-unit: 1 km >= 1000 m
        expect(1.0.kilometers >= 1000.0.meters, isTrue);
      });

      test('operator <=', () {
        expect(2.0.meters <= 2.0.meters, isTrue);
        expect(1.0.meters <= 2.0.meters, isTrue);
        expect(2.0.meters <= 1.0.meters, isFalse);
        // cross-unit: 1000 m <= 1 km
        expect(1000.0.meters <= 1.0.kilometers, isTrue);
      });
    });

    test('hashCode', () {
      final a = 1.0.meters;
      final b = 1.0.meters;
      final c = 2.0.meters;

      expect(a.hashCode, equals(b.hashCode));
      expect(a.hashCode, isNot(equals(c.hashCode)));
    });
  });
}
