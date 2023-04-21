import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

void main(List<String> args) async {
  IO<int> readGuess() => IO
      .print('Guess a number [1-10]: ')
      .productR(() => IO.readLine())
      .flatMap(
        (line) => IO.fromOption(
          Option.of(int.tryParse(line)),
          () => 'Invalid guess: $line',
        ),
      )
      .handleErrorWith(
        (e) => IO.println(e.message.toString()).flatMap((a) => readGuess()),
      );

  IO<Unit> game(int answer) => readGuess().flatMap((n) {
        if (n == answer) {
          return IO.println('Correct!');
        } else if (n < answer) {
          return IO.println('Too low').productR(() => game(answer));
        } else {
          return IO.println('Too high').productR(() => game(answer));
        }
      });

  await game(Random().nextInt(10) + 1).unsafeRunToFuture();
}
