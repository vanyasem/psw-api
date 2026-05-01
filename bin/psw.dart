import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:psw/src/commands/menu_command.dart';
import 'package:psw/src/commands/orders_command.dart';

Future<void> main(List<String> args) async {
  final runner =
      CommandRunner<int>(
          'psw',
          'PSW data downloader. Run a subcommand to fetch data.',
        )
        ..addCommand(OrdersCommand())
        ..addCommand(MenuCommand());

  try {
    final exitCode = await runner.run(args) ?? 0;
    exit(exitCode);
  } on UsageException catch (e) {
    stderr.writeln(e);
    exit(64);
  }
}
