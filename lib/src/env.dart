import 'dart:io';

class Env {
  Env({required this.accessToken, required this.userId});

  final String accessToken;
  final String userId;

  static Env load(File file) {
    if (!file.existsSync()) {
      throw EnvException('${file.path} not found');
    }
    final values = <String, String>{};
    for (final raw in file.readAsLinesSync()) {
      final line = raw.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final eq = line.indexOf('=');
      if (eq <= 0) continue;
      final key = line.substring(0, eq).trim();
      var value = line.substring(eq + 1).trim();
      if (value.length >= 2 &&
          ((value.startsWith('"') && value.endsWith('"')) ||
              (value.startsWith("'") && value.endsWith("'")))) {
        value = value.substring(1, value.length - 1);
      }
      values[key] = value;
    }
    final accessToken = values['access_token'];
    final userId = values['userID'];
    if (accessToken == null || accessToken.isEmpty) {
      throw EnvException('access_token missing in ${file.path}');
    }
    if (userId == null || userId.isEmpty) {
      throw EnvException('userID missing in ${file.path}');
    }
    return Env(accessToken: accessToken, userId: userId);
  }
}

class EnvException implements Exception {
  EnvException(this.message);
  final String message;
  @override
  String toString() => message;
}
