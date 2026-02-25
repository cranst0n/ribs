import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

void main() async {
  // A simple IO that prints a message
  final hello = IO.print('Hello, Ribs!');

  // Combine two IOs sequentially
  final sequential = hello.flatMap((_) => IO.print('Sequential execution'));

  // Run multiple IOs concurrently
  final concurrent =
      ilist([
        IO.sleep(const Duration(milliseconds: 500)).flatMap((_) => IO.print('Task 1 done')),
        IO.sleep(const Duration(milliseconds: 200)).flatMap((_) => IO.print('Task 2 done')),
        IO.sleep(const Duration(milliseconds: 400)).flatMap((_) => IO.print('Task 3 done')),
      ]).parSequence();

  // Safe resource management with bracket
  final resourceUsage = IO
      .print('Acquiring resource...')
      .bracket(
        (_) => IO.print('Using resource...'),
        (_) => IO.print('Releasing resource...'),
      );

  // Putting it all together
  final program = sequential
      .flatMap((_) => concurrent)
      .flatMap((_) => resourceUsage)
      .flatMap((_) => IO.print('Program finished!'));

  // Run the program
  await program.unsafeRunFuture();
}
