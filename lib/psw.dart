import 'dart:io';

import 'src/api_client.dart';
import 'src/env.dart';
import 'src/orders_source.dart';

class OrderDownloader {
  OrderDownloader({
    required this.client,
    required this.outputDir,
    Stdout? out,
    Stdout? err,
  }) : _out = out ?? stdout,
       _err = err ?? stderr;

  final ApiClient client;
  final Directory outputDir;
  final Stdout _out;
  final Stdout _err;

  Future<DownloadSummary> run(List<String> orderIds) async {
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }
    var skipped = 0;
    var fetched = 0;
    var failed = 0;
    for (final orderId in orderIds) {
      final file = File('${outputDir.path}/$orderId.json');
      if (file.existsSync()) {
        skipped++;
        _out.writeln('skip $orderId (exists)');
        continue;
      }
      try {
        final body = await client.getOrderInformation(orderId);
        file.writeAsStringSync(body);
        fetched++;
        _out.writeln('saved $orderId');
      } catch (e) {
        failed++;
        _err.writeln('error $orderId: $e');
      }
    }
    return DownloadSummary(
      total: orderIds.length,
      fetched: fetched,
      skipped: skipped,
      failed: failed,
    );
  }
}

class DownloadSummary {
  DownloadSummary({
    required this.total,
    required this.fetched,
    required this.skipped,
    required this.failed,
  });

  final int total;
  final int fetched;
  final int skipped;
  final int failed;

  @override
  String toString() =>
      'total=$total fetched=$fetched skipped=$skipped failed=$failed';
}

Future<int> runCli({
  required File envFile,
  required File ordersFile,
  required Directory outputDir,
}) async {
  final Env env;
  try {
    env = Env.load(envFile);
  } on EnvException catch (e) {
    stderr.writeln(e.message);
    return 1;
  }

  final List<String> orderIds;
  try {
    orderIds = OrdersSource.readOrderIds(ordersFile);
  } on OrdersSourceException catch (e) {
    stderr.writeln(e.message);
    return 1;
  }

  final client = ApiClient(accessToken: env.accessToken, userId: env.userId);
  try {
    final downloader = OrderDownloader(client: client, outputDir: outputDir);
    final summary = await downloader.run(orderIds);
    stdout.writeln(summary);
    return 0;
  } finally {
    client.close();
  }
}
