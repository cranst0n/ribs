import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

// naive

int naiveMax(List<int> xs) {
  if (xs.isEmpty) {
    throw UnimplementedError('What do we do?');
  } else {
    return xs.reduce((maxSoFar, element) => max(maxSoFar, element));
  }
}

// naive

// better

Option<int> betterMax(List<int> xs) {
  if (xs.isEmpty) {
    return const None();
  } else {
    return Some(xs.reduce((maxSoFar, element) => max(maxSoFar, element)));
  }
}

// better

// better-yet

Option<int> betterYetMax(List<int> xs) =>
    Option.when(() => xs.isNotEmpty, () => xs.reduce(max));

// better-yet

// combinators-1

int? foo(String s) => throw UnimplementedError();
double bar(int s) => throw UnimplementedError();

// How can we pipe these 2 functions together to acheive this:
// final result = bar(foo('string'));

// combinators-1

// combinators-2

// How can we pipe these 2 functions together to acheive this:
final resA = foo('string');
final result = resA != null ? bar(resA!) : null;

// combinators-2

// combinators-3

Option<int> fooOpt(String s) => throw UnimplementedError();
double barOpt(int s) => throw UnimplementedError();

final resultOpt = fooOpt('string').map((i) => barOpt(i));

// combinators-3

// flatmap-1

Option<String> validate(String s) => Option.when(() => s.isNotEmpty, () => s);
Option<String> firstName(String s) {
  final parts = s.split(' ');
  if (parts.length == 2) {
    return Some(parts.first);
  } else {
    return const None();
  }
}

final nameA = validate('John Doe').flatMap(firstName); // Some('John')
final nameB = validate('Madonna').flatMap(firstName); // None

// flatmap-1

// mapN-1

const firstN = Some('Tommy');
const middleN = Some('Lee');
const lastN = Some('Jones');

// Combine the 3 name parts into full name
final fullName1 = firstN.flatMap(
  (first) => middleN.flatMap(
    (middle) => lastN.map(
      (last) => '$first $middle $last',
    ),
  ),
);

// mapN-1

// mapN-2

// Combine the 3 name parts into full name using mapN
final fullName2 = (firstN, middleN, lastN).mapN((f, m, l) => '$f $m $l');

// mapN-2
