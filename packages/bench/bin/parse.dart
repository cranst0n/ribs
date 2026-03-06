// ignore_for_file: avoid_print

import 'package:ribs_bench/parse/parse_bench.dart';
import 'package:ribs_bench/ribs_benchmark.dart';

void main(List<String> args) {
  const shortToken = 'Content-Type';
  const longToken = 'X-Custom-Request-Header-With-A-Long-Name';
  const shortHeader = 'Content-Type: text/html';
  const longHeader = 'X-Forwarded-For: 192.168.1.1, 10.0.0.1, 172.16.0.1';
  const shortCsv = 'gzip, deflate';
  const longCsv = 'gzip, deflate, br, zstd, identity, compress';
  const shortRequest = 'GET /index.html HTTP/1.1';
  const longRequest = 'POST /api/v2/users/profile/settings?lang=en&theme=dark HTTP/1.1';

  print('=== Token ===\n');
  RibsBenchmark.runAndReport([
    RibsTokenBenchmark(shortToken),
    PpTokenBenchmark(shortToken),
  ]);
  RibsBenchmark.runAndReport([
    RibsTokenBenchmark(longToken),
    PpTokenBenchmark(longToken),
  ]);

  print('\n=== Status Code ===\n');
  RibsBenchmark.runAndReport([
    RibsStatusCodeBenchmark(),
    PpStatusCodeBenchmark(),
  ]);

  print('\n=== HTTP Version ===\n');
  RibsBenchmark.runAndReport([
    RibsHttpVersionBenchmark(),
    PpHttpVersionBenchmark(),
  ]);

  print('\n=== Header Field ===\n');
  RibsBenchmark.runAndReport([
    RibsHeaderFieldBenchmark(shortHeader),
    PpHeaderFieldBenchmark(shortHeader),
  ]);
  RibsBenchmark.runAndReport([
    RibsHeaderFieldBenchmark(longHeader),
    PpHeaderFieldBenchmark(longHeader),
  ]);

  print('\n=== CSV Tokens ===\n');
  RibsBenchmark.runAndReport([
    RibsCsvTokenBenchmark(shortCsv),
    PpCsvTokenBenchmark(shortCsv),
  ]);
  RibsBenchmark.runAndReport([
    RibsCsvTokenBenchmark(longCsv),
    PpCsvTokenBenchmark(longCsv),
  ]);

  print('\n=== Request Line ===\n');
  RibsBenchmark.runAndReport([
    RibsRequestLineBenchmark(shortRequest),
    PpRequestLineBenchmark(shortRequest),
  ]);
  RibsBenchmark.runAndReport([
    RibsRequestLineBenchmark(longRequest),
    PpRequestLineBenchmark(longRequest),
  ]);

  print('\n=== Multi-Header Block (6 headers) ===\n');
  RibsBenchmark.runAndReport([
    RibsMultiHeaderBenchmark(),
    PpMultiHeaderBenchmark(),
  ]);

  print('\n=== Full HTTP/1.1 Request (request-line + 6 headers) ===\n');
  RibsBenchmark.runAndReport([
    RibsFullRequestBenchmark(),
    PpFullRequestBenchmark(),
  ]);

  print('\n=== Large CSV (20 tokens) ===\n');
  RibsBenchmark.runAndReport([
    RibsLargeCsvBenchmark(),
    PpLargeCsvBenchmark(),
  ]);
}
