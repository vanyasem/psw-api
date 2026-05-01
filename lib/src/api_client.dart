import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({
    required this.accessToken,
    required this.userId,
    http.Client? client,
  }) : _client = client ?? http.Client();

  static final Uri _orderInformation = Uri.parse(
    'https://dataexchange.psweb.pro/api/order.getInformation',
  );
  static final Uri _orderHistory = Uri.parse(
    'https://dataexchange.psweb.pro/api/order.getHistory',
  );

  final String accessToken;
  final String userId;
  final http.Client _client;

  Future<String> getOrderInformation(String orderId) async {
    final uri = _orderInformation.replace(
      queryParameters: {
        'access_token': accessToken,
        'orderID': orderId,
        'userID': userId,
      },
    );
    return _getBody(uri, 'orderID=$orderId');
  }

  Future<String> getOrderHistory() async {
    final uri = _orderHistory.replace(
      queryParameters: {'access_token': accessToken, 'userID': userId},
    );
    return _getBody(uri, 'order.getHistory');
  }

  Future<String> _getBody(Uri uri, String context) async {
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw ApiException(
        'HTTP ${response.statusCode} for $context',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
    return response.body;
  }

  void close() => _client.close();
}

class ApiException implements Exception {
  ApiException(this.message, {required this.statusCode, required this.body});
  final String message;
  final int statusCode;
  final String body;
  @override
  String toString() => message;
}
