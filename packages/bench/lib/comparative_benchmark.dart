import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:chalkdart/chalk.dart';
import 'package:cli_table/cli_table.dart';
import 'package:ribs_core/ribs_core.dart';

class ComparativeBenchmark<C> extends BenchmarkBase {
  final C Function() gen;
  final Function1<C, C> op;

  late C c;

  static const _Sep = '<@!@!@>';

  ComparativeBenchmark(
    String library,
    String operation,
    this.gen,
    this.op,
    ComparativeEmitter emitter,
  ) : super('$library$_Sep$operation', emitter: emitter);

  @override
  void setup() {
    c = gen();
  }

  @override
  void run() {
    op(c);
  }
}

class ComparativeEmitter implements ScoreEmitter {
  final String title;
  final Map<(String, String), double> values = {};

  ComparativeEmitter(this.title);

  @override
  void emit(String testName, double value) {
    final [lib, op] = testName.split(ComparativeBenchmark._Sep);

    values[(lib, op)] = value;
  }

  String renderCliTable() {
    final libs = libraries();
    final ops = operations();

    final table = Table(
      style: TableStyle.noColor(),
      header: [
        {
          'content': title,
          'colSpan': ops.size + 1,
          'hAlign': HorizontalAlign.center,
        }
      ],
      columnAlignment: [
        HorizontalAlign.left,
        ...List.filled(ops.length, HorizontalAlign.right),
      ],
    );

    table.add({'': ops.toList()});

    libs.foreach((lib) {
      final opValues = ops.map((op) {
        final bestValue =
            imap(values).filter((kv) => kv.$1.$2 == op).values.minOption(Order.doubles);

        return Option(values[(lib, op)]).fold(
          () => chalk.dim.grey('n/a'),
          (value) => bestValue.fold(
            () => _formatValue(value),
            (best) => value == best ? chalk.green(_formatValue(value)) : _formatValue(value),
          ),
        );
      }).toList();

      table.add([lib, ...opValues]);
    });

    return table.toString();
  }

  String renderMarkdownTable() {
    final libs = libraries();
    final ops = operations();

    final buf = StringBuffer();

    buf.writeln(
      ops.prepended(title).mkString(start: '| ', sep: ' | ', end: ' |'),
    );

    buf.writeln(
      IList.tabulate(ops.size + 1, (ix) => ix == 0 ? ':---' : '---:')
          .mkString(start: '| ', sep: ' | ', end: ' |'),
    );

    libs.foreach((lib) {
      final cells = ops.map((op) {
        final bestValue =
            imap(values).filter((kv) => kv.$1.$2 == op).values.minOption(Order.doubles);

        return Option(values[(lib, op)]).fold(
          () => ' ',
          (value) => bestValue.fold(
            () => _formatValue(value),
            (best) => value == best ? '**${_formatValue(value)}**' : _formatValue(value),
          ),
        );
      }).prepended(lib);

      buf.writeln(
        cells.mkString(start: '| ', sep: ' | ', end: ' |'),
      );
    });

    return buf.toString();
  }

  String _formatValue(double val) => val.toStringAsFixed(2);

  IList<String> libraries() =>
      IList.fromDart(values.keys.map((e) => e.$1)).distinct().sorted(Order.strings);

  IList<String> operations() =>
      IList.fromDart(values.keys.map((e) => e.$2)).distinct().sorted(Order.strings);
}
