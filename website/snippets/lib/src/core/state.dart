// ignore_for_file: avoid_print

import 'package:ribs_core/ribs_core.dart';

// motivation-before

final class GameStatePlain {
  final int health;
  final int gold;
  final List<String> inventory;

  const GameStatePlain({
    required this.health,
    required this.gold,
    required this.inventory,
  });
}

GameStatePlain takeDamagePlain(GameStatePlain state, int amount) => GameStatePlain(
  health: state.health - amount,
  gold: state.gold,
  inventory: state.inventory,
);

GameStatePlain collectGoldPlain(GameStatePlain state, int amount) => GameStatePlain(
  health: state.health,
  gold: state.gold + amount,
  inventory: state.inventory,
);

GameStatePlain pickUpItemPlain(GameStatePlain state, String item) => GameStatePlain(
  health: state.health,
  gold: state.gold,
  inventory: [...state.inventory, item],
);

bool isAlivePlain(GameStatePlain state) => state.health > 0;

bool exploreForestPlain(GameStatePlain initial) {
  final s1 = takeDamagePlain(initial, 15);
  final s2 = collectGoldPlain(s1, 30);
  final s3 = pickUpItemPlain(s2, 'Herbal Remedy');
  return isAlivePlain(s3);
}

// motivation-before

// state-model

final class GameState {
  final int health;
  final int gold;
  final IList<String> inventory;

  const GameState({
    required this.health,
    required this.gold,
    required this.inventory,
  });

  GameState copy({int? health, int? gold, IList<String>? inventory}) => GameState(
    health: health ?? this.health,
    gold: gold ?? this.gold,
    inventory: inventory ?? this.inventory,
  );

  @override
  String toString() => 'GameState(health: $health, gold: $gold, items: $inventory)';
}

// state-model

// state-ops

State<GameState, Unit> takeDamage(int amount) =>
    State((s) => (s.copy(health: s.health - amount), Unit()));

State<GameState, Unit> collectGold(int amount) =>
    State((s) => (s.copy(gold: s.gold + amount), Unit()));

State<GameState, Unit> pickUpItem(String item) =>
    State((s) => (s.copy(inventory: s.inventory.appended(item)), Unit()));

State<GameState, int> currentHealth() => State((s) => (s, s.health));

State<GameState, bool> isAlive() => State((s) => (s, s.health > 0));

// state-ops

// state-compose

State<GameState, bool> exploreForest() => takeDamage(15)
    .flatMap((_) => collectGold(30))
    .flatMap((_) => pickUpItem('Herbal Remedy'))
    .flatMap((_) => isAlive());

State<GameState, bool> stormCastle() => takeDamage(40)
    .flatMap((_) => collectGold(100))
    .flatMap((_) => pickUpItem('Ancient Sword'))
    .flatMap((_) => isAlive());

// state-compose

// state-run

void runAdventure() {
  final initial = GameState(
    health: 100,
    gold: 0,
    inventory: nil(),
  );

  final adventure = exploreForest().flatMap(
    (bool survived) => survived ? stormCastle() : State.pure<GameState, bool>(false),
  );

  final (finalState, won) = adventure.run(initial);

  print('Adventure complete! Won: $won');
  print('Final state: $finalState');

  // Adventure complete! Won: true
  // GameState(health: 45, gold: 130, items: [Herbal Remedy, Ancient Sword])
}

// state-run

// state-runas

void runParts() {
  final initial = GameState(
    health: 100,
    gold: 0,
    inventory: nil(),
  );

  // Only care about the result value
  final survived = exploreForest().runA(initial); // true

  // Only care about the final state
  final stateAfter = exploreForest().runS(initial);

  print('Survived: $survived');
  print('State: $stateAfter');
}

// state-runas
