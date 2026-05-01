import 'dart:io';

import 'package:args/command_runner.dart';

import '../../psw.dart';

class MenuCommand extends Command<int> {
  @override
  String get name => 'menu';

  @override
  String get description =>
      'Fetch the menu and save raw JSON to data/menu.json.';

  @override
  Future<int> run() async {
    final cwd = Directory.current;
    return runMenuPipeline(menuFile: File('${cwd.path}/data/menu.json'));
  }
}
