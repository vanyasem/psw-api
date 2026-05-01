import 'dart:convert';
import 'dart:io';

import 'src/api_client.dart';
import 'src/env.dart';
import 'src/menu_index.dart';
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

Future<int> runOrdersPipeline({
  required File envFile,
  required File historyFile,
  required Directory outputDir,
}) async {
  final Env env;
  try {
    env = Env.load(envFile);
  } on EnvException catch (e) {
    stderr.writeln(e.message);
    return 1;
  }

  final client = ApiClient(accessToken: env.accessToken, userId: env.userId);
  try {
    final String historyBody;
    try {
      historyBody = await client.getOrderHistory();
    } on ApiException catch (e) {
      stderr.writeln('failed to fetch order history: $e');
      return 1;
    }

    final parent = historyFile.parent;
    if (!parent.existsSync()) {
      parent.createSync(recursive: true);
    }
    historyFile.writeAsStringSync(historyBody);

    final List<String> orderIds;
    try {
      orderIds = OrdersSource.parseOrderIds(
        historyBody,
        source: 'order.getHistory',
      );
    } on OrdersSourceException catch (e) {
      stderr.writeln(e.message);
      return 1;
    }

    final downloader = OrderDownloader(client: client, outputDir: outputDir);
    final summary = await downloader.run(orderIds);
    stdout.writeln(summary);
    return 0;
  } finally {
    client.close();
  }
}

Future<int> runMenuPipeline({required File menuFile}) async {
  final String body;
  try {
    body = await ApiClient.fetchMenu();
  } on ApiException catch (e) {
    stderr.writeln('failed to fetch menu: $e');
    return 1;
  }

  final parent = menuFile.parent;
  if (!parent.existsSync()) {
    parent.createSync(recursive: true);
  }
  menuFile.writeAsStringSync(body);
  stdout.writeln('saved ${menuFile.path}');
  return 0;
}

Future<int> runReportPipeline({
  required File menuFile,
  required Directory ordersDir,
}) async {
  final MenuIndex menu;
  try {
    menu = MenuIndex.readFile(menuFile);
  } on MenuIndexException catch (e) {
    stderr.writeln(e.message);
    return 1;
  }

  if (!ordersDir.existsSync()) {
    stderr.writeln('${ordersDir.path} not found');
    return 1;
  }

  final orderFiles = ordersDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in orderFiles) {
    final orderId = file.uri.pathSegments.last.replaceAll('.json', '');
    final dynamic decoded;
    try {
      decoded = jsonDecode(file.readAsStringSync());
    } on FormatException catch (e) {
      stderr.writeln('${file.path}: invalid JSON (${e.message})');
      continue;
    }
    if (decoded is! Map<String, dynamic>) {
      stderr.writeln('${file.path}: expected top-level JSON object');
      continue;
    }
    final orderDate = decoded['orderDate'] is String
        ? decoded['orderDate'] as String
        : '';
    final positions = decoded['orderPositions'];
    if (positions is! Map<String, dynamic>) {
      stderr.writeln('${file.path}: expected "orderPositions" to be an object');
      continue;
    }

    stdout.writeln(
      orderDate.isEmpty ? 'Order $orderId:' : 'Order $orderId ($orderDate):',
    );

    final keys = positions.keys.toList()
      ..sort((a, b) {
        final ai = int.tryParse(a);
        final bi = int.tryParse(b);
        if (ai != null && bi != null) return ai.compareTo(bi);
        return a.compareTo(b);
      });

    for (final key in keys) {
      final entry = positions[key];
      if (entry is! Map<String, dynamic>) continue;
      final positionId = entry['positionID']?.toString() ?? '';
      final price = entry['price'];
      final amount = entry['amount'];
      final name = menu.nameFor(positionId);
      if (name == null) {
        stderr.writeln(
          'warn: order $orderId positionID $positionId not in menu',
        );
        stdout.writeln('  <unknown $positionId> | $price | $amount');
      } else {
        stdout.writeln('  $name | $price | $amount');
      }
    }
  }

  return 0;
}
