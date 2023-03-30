import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

typedef Candy = String;

const Gum = 'Gum';
const Lollipop = 'Lollipop';
const Snickers = 'Snickers';

typedef CandyMachine = State<int, IList<Candy>>;

extension CandyMachineOps on CandyMachine {
  CandyMachine get eatGum => _eat(Gum);
  CandyMachine get eatLollipop => _eat(Lollipop);
  CandyMachine get eatSnickers => _eat(Snickers);

  CandyMachine get insertNickel => modify((a) => a + 5);
  CandyMachine get insertDime => modify((a) => a + 10);
  CandyMachine get insertQuarter => modify((a) => a + 25);

  CandyMachine get redeemGum => _extract(5, Gum);
  CandyMachine get redeemLollipop => _extract(20, Lollipop);
  CandyMachine get redeemSnickers => _extract(55, Snickers);

  CandyMachine _eat(Candy candy) =>
      map((myCandy) => myCandy.removeFirst((c) => c == candy));

  CandyMachine _extract(int cost, Candy candy) =>
      transform((s, a) => s >= cost ? (s - cost, a.append(candy)) : (s, a));
}

void main() {
  final machine = State.pure<int, IList<Candy>>(IList.empty());

  test('State.pure', () {
    expect(machine.run(0), (0, IList.empty<Candy>()));
  });

  test('Redeem exact', () {
    expect(
      machine.insertDime.insertDime.redeemLollipop.run(0),
      (0, IList.of([Lollipop])),
    );
  });

  test('Redeem with change', () {
    expect(
      machine.insertDime.insertDime.insertNickel.redeemLollipop.run(0),
      (5, IList.of([Lollipop])),
    );
  });

  test('Not enough', () {
    expect(
      machine.insertDime.insertNickel.redeemLollipop.run(0),
      (15, IList.of([])),
    );
  });

  test('Redeem and Eat', () {
    expect(
      machine.insertQuarter.redeemGum.redeemGum.redeemGum.eatGum.eatGum.run(0),
      (10, IList.of([Gum])),
    );
  });

  test('State.runA', () {
    expect(machine.insertQuarter.runA(0), IList.empty<Candy>());
  });

  test('State.runS', () {
    expect(machine.insertQuarter.insertDime.runS(0), 35);
  });

  test('State.state', () {
    expect(machine.insertNickel.insertDime.state().runA(0), 15);
  });

  test('State.ap', () {
    expect(
      machine.insertDime.redeemGum.redeemGum
          .ap(State.pure((l) => l.size))
          .runA(0),
      2,
    );
  });
}
