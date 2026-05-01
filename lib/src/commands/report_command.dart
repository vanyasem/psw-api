import 'dart:io';

import 'package:args/command_runner.dart';

import '../../psw.dart';

class ReportCommand extends Command<int> {
  @override
  String get name => 'report';

  @override
  String get description =>
      'Match saved orders against the menu and print resolved items.';

  @override
  Future<int> run() async {
    final cwd = Directory.current;
    return runReportPipeline(
      menuFile: File('${cwd.path}/data/menu.json'),
      ordersDir: Directory('${cwd.path}/data/orders'),
    );
  }
}
