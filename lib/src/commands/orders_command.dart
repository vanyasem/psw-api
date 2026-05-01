import 'dart:io';

import 'package:args/command_runner.dart';

import '../../psw.dart';

class OrdersCommand extends Command<int> {
  @override
  String get name => 'orders';

  @override
  String get description =>
      'Fetch order history and download each order to data/orders/.';

  @override
  Future<int> run() async {
    final cwd = Directory.current;
    return runOrdersPipeline(
      envFile: File('${cwd.path}/.env'),
      historyFile: File('${cwd.path}/data/history.json'),
      outputDir: Directory('${cwd.path}/data/orders'),
    );
  }
}
