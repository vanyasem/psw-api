import 'dart:io';

import 'package:psw/psw.dart';

Future<void> main(List<String> args) async {
  final cwd = Directory.current;
  final exitCode = await runCli(
    envFile: File('${cwd.path}/.env'),
    ordersFile: File('${cwd.path}/orders.json'),
    outputDir: Directory('${cwd.path}/data/orders'),
  );
  exit(exitCode);
}
