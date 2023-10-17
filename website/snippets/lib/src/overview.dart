// ignore_for_file: avoid_print, unused_local_variable, dangling_library_doc_comments

// overview-1

int opCount = 0;

int performOp(int a, int b) {
  opCount += 1; // Mutating global variable!
  return a + b;
}

// overview-1

// overview-2

int multiply(int a, int b) {
  print('multipying $a x $b'); // Side effect!
  return a * b;
}

// overview-2

// overview-3

final class Tracker {
  int count = 0;

  Tracker();
}

int doubleHeadAndSum(int a, int b, Tracker tracker) {
  tracker.count += 1; // Modifying a field on the Tracker parameter
  return a + b * a;
}

// overview-3

// overview-4

bool fireMissile(int passcode) {
  if (passcode == 123) {
    return true;
  } else {
    throw Exception('Missle launch aborted: Invalid passcode!');
  }
}

// overview-4

// overview-5

int pureAdd(int a, int b) => a + b;

// overview-5

// overview-6

final class Counter {
  int count = 0;

  Counter add() {
    count += 1;
    return this;
  }
}

final counter = Counter();
final b = counter.add();
final resA = b.count;
final resB = b.count;

final areEqual = resA == resB; // Both values here equal 1

// overview-6

void snippet7() {
  // overview-7

  final counter = Counter();
  // final b = a.add(); // We replace all occurances of b with a.add();
  final resA = counter.add().count;
  final resB = counter.add().count;

  final areEqual = resA == resB; // Oh no! resA == 1 while resB == 2!

  // overview-7
}
