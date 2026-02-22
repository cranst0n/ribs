// ignore_for_file: avoid_print
import 'package:ribs_core/ribs_core.dart';

// A sample application showing off some of the key features of ribs_core, using
// some of the core datatypes provided by the library.

sealed class BankAction {
  /// Validates raw inputs into `BankAction` using `ValidatedNel`.
  ///
  /// By using `ValidatedNel`, we can accumulate multiple errors instead of
  /// stopping at the first failure if we were validating multiple independent fields.
  static ValidatedNel<String, BankAction> parse(String actionType, int amount) {
    final ValidatedNel<String, int> validatedAmount =
        amount <= 0 ? "Amount must be greater than 0".invalidNel<int>() : amount.validNel<String>();

    final ValidatedNel<String, Function1<int, BankAction>> validatedAction = switch (actionType) {
      "deposit" => Deposit.new.validNel(),
      "withdraw" => Withdraw.new.validNel(),
      _ => "Unknown action type: $actionType".invalidNel(),
    };

    return validatedAmount.product(validatedAction).map((tuple) => tuple.$2(tuple.$1));
  }
}

class Deposit extends BankAction {
  final int amount;
  Deposit(this.amount);
}

class Withdraw extends BankAction {
  final int amount;
  Withdraw(this.amount);
}

/// Maintains a current balance and a history of transactions.
class BankState {
  final int balance;
  final IList<String> history;

  BankState(this.balance, this.history);

  BankState update(int newBalance, String message) =>
      BankState(newBalance, history.appended(message));
}

/// A `State` computation that takes a valid `BankAction` and returns an
/// `Either<String, String>` describing success (Right) or failure (Left),
/// mutating the `BankState` along the way without actual side-effects.
State<BankState, Either<String, String>> processAction(BankAction action) {
  return State(
    (state) => switch (action) {
      Deposit(amount: final amt) => (
        state.update(state.balance + amt, "Deposited \$$amt"),
        Right("Success: Deposited \$$amt"),
      ),
      Withdraw(amount: final amt) =>
        state.balance >= amt
            ? (
              state.update(state.balance - amt, "Withdrew \$$amt"),
              Right("Success: Withdrew \$$amt"),
            )
            : (
              state,
              Left("Error: Insufficient funds for withdrawal of \$$amt"),
            ),
    },
  );
}

void main() {
  // Let's create an immutable list of potential tasks.
  final actions = ilist([
    ("deposit", 100),
    ("withdraw", 50),
    ("withdraw", 200), // Should fail due to insufficient funds later
    ("invalid_type", -10), // Should fail validation with multiple errors
    ("deposit", -5), // Should fail validation
  ]);

  print('Validating Actions...');
  print('-' * 100);

  // Validate the inputs
  final parsedActions = actions.map((tuple) => BankAction.parse(tuple.$1, tuple.$2));

  // Partition parsed actions into failures and valid actions (Lefts = errors, Rights = succeess)
  final (failures, validActions) = parsedActions.partitionMap((v) => v.toEither());

  if (failures.nonEmpty) {
    print('\nValidation Failures:');
    failures.foreach((errs) => print('  - ${errs.mkString(sep: ", ")}'));
  }

  print('\nProcessing Valid Actions...');
  print('-' * 100);

  // Create an initial state
  final initialState = BankState(0, nil());

  // We fold Left over our validActions, threaded with the current BankState
  final BankState finalState = validActions.foldLeft(initialState, (state, action) {
    // Run our State Monad using the current state
    final (nextState, result) = processAction(action).run(state);

    // Pattern match out result which is an Either
    result.fold((error) => print('  $error'), (success) => print('  $success'));

    return nextState;
  });

  print('\nEnd Result:');
  print('-' * 100);
  print('Final Bank Balance: \$${finalState.balance}');
  print('Transaction History:');
  finalState.history.foreach((msg) => print('  > $msg'));
}
