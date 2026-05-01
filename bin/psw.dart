import 'dart:io';

import 'package:psw/psw.dart';

Future<void> main(List<String> args) async {
  final cwd = Directory.current;
  final exitCode = await runCli(
    envFile: File('${cwd.path}/.env'),
    historyFile: File('${cwd.path}/data/history.json'),
    outputDir: Directory('${cwd.path}/data/orders'),
  );
  exit(exitCode);
}
