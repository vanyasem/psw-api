import 'dart:convert';
import 'dart:io';

class OrdersSource {
  static List<String> readOrderIds(File file) {
    if (!file.existsSync()) {
      throw OrdersSourceException('${file.path} not found');
    }
    return parseOrderIds(file.readAsStringSync(), source: file.path);
  }

  static List<String> parseOrderIds(String json, {String source = 'response'}) {
    final decoded = jsonDecode(json);
    if (decoded is! Map<String, dynamic>) {
      throw OrdersSourceException('$source: expected top-level JSON object');
    }
    final orders = decoded['orders'];
    if (orders is! Map<String, dynamic>) {
      throw OrdersSourceException('$source: expected "orders" to be an object');
    }
    final ids = <String>[];
    for (final entry in orders.values) {
      if (entry is Map<String, dynamic>) {
        final id = entry['orderID'];
        if (id is String && id.isNotEmpty) {
          ids.add(id);
        }
      }
    }
    return ids;
  }
}

class OrdersSourceException implements Exception {
  OrdersSourceException(this.message);
  final String message;
  @override
  String toString() => message;
}
