// ignore_for_file: avoid_print

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';

// Example domain models

class Address {
  final String street;
  final String city;

  Address(this.street, this.city);

  Address copyWith({String? street, String? city}) =>
      Address(street ?? this.street, city ?? this.city);

  @override
  String toString() => 'Address(street: $street, city: $city)';
}

class User {
  final String name;
  final Address address;

  User(this.name, this.address);

  User copyWith({String? name, Address? address}) =>
      User(name ?? this.name, address ?? this.address);

  @override
  String toString() => 'User(name: $name, address: $address)';
}

sealed class Shape {}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);
  @override
  String toString() => 'Circle(radius: $radius)';
}

class Square extends Shape {
  final double side;
  Square(this.side);
  @override
  String toString() => 'Square(side: $side)';
}

// Optics Definitions

final addressL = Lens<User, Address>(
  (u) => u.address,
  (a) => (u) => u.copyWith(address: a),
);

final streetL = Lens<Address, String>(
  (a) => a.street,
  (s) => (a) => a.copyWith(street: s),
);

final cityL = Lens<Address, String>(
  (a) => a.city,
  (c) => (a) => a.copyWith(city: c),
);

// Composed Optics
final userStreetL = addressL.andThenL(streetL);
final userCityL = addressL.andThenL(cityL);

final circleP = Prism<Shape, Circle>(
  (s) => s is Circle ? s.asRight() : s.asLeft(),
  (c) => c,
);

final radiusL = Lens<Circle, double>(
  (c) => c.radius,
  (r) => (c) => Circle(r),
);

void main() {
  final user = User(
    'Alice',
    Address('123 functional way', 'Type City'),
  );

  print('Original User:');
  print(user);

  // Basic Get
  print('\nStreet via Lens: ${userStreetL.get(user)}');

  // Deep Update (Replace)
  final movedUser = userStreetL.replace('456 logic lane')(user);
  print('\nMoved User:');
  print(movedUser);

  // Deep Update (Modify)
  final shoutingCityUser = userCityL.modify((city) => city.toUpperCase())(user);
  print('\nUser with shouting city:');
  print(shoutingCityUser);

  // Using Optional for potential values
  final firstCharO = Optional<String, String>(
    (s) => s.isNotEmpty ? s.substring(0, 1).asRight() : s.asLeft(),
    (c) => (s) => s.isNotEmpty ? c + s.substring(1) : s,
  );

  final userStreetFirstCharO = userStreetL.andThenO(firstCharO);

  final capitalizedStreetUser = userStreetFirstCharO.modify((c) => c.toUpperCase())(user);

  print('\nCapitalized street first char:');
  print(capitalizedStreetUser);

  // Prism: Only update if the shape is a Circle
  Shape shape = Circle(10.0);
  final shapeRadiusO = circleP.andThenO(radiusL);

  print('\nOriginal Shape: $shape');
  print('Bigger Shape: ${shapeRadiusO.modify((r) => r * 2)(shape)}');

  shape = Square(5.0);
  print('\nOriginal Shape: $shape');
  print('Bigger Shape: ${shapeRadiusO.modify((r) => r * 2)(shape)}');
}
