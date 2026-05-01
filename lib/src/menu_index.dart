import 'dart:convert';
import 'dart:io';

class MenuIndex {
  MenuIndex(this._namesById);

  final Map<String, String> _namesById;

  String? nameFor(String positionId) => _namesById[positionId];

  static MenuIndex readFile(File file) {
    if (!file.existsSync()) {
      throw MenuIndexException('${file.path} not found');
    }
    return fromJson(file.readAsStringSync(), source: file.path);
  }

  static MenuIndex fromJson(String body, {String source = 'menu.json'}) {
    final dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } on FormatException catch (e) {
      throw MenuIndexException('$source: invalid JSON (${e.message})');
    }
    if (decoded is! Map<String, dynamic>) {
      throw MenuIndexException('$source: expected top-level JSON object');
    }
    final positions = decoded['positions'];
    if (positions is! Map<String, dynamic>) {
      throw MenuIndexException(
        '$source: expected "positions" to be an object',
      );
    }
    final names = <String, String>{..._retiredItems};
    for (final category in positions.values) {
      if (category is! Map<String, dynamic>) continue;
      for (final entry in category.entries) {
        final item = entry.value;
        if (item is! Map<String, dynamic>) continue;
        final name = item['name'];
        if (name is String && name.isNotEmpty) {
          names[entry.key] = name;
        }
      }
    }
    return MenuIndex(names);
  }
}

// Retired items missing from the current menu but still referenced by old
// orders.
const Map<String, String> _retiredItems = {
  '586': 'Палочки для суши',
};

class MenuIndexException implements Exception {
  MenuIndexException(this.message);
  final String message;
  @override
  String toString() => message;
}
