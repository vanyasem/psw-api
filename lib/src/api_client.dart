import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({
    required this.accessToken,
    required this.userId,
    http.Client? client,
  }) : _client = client ?? http.Client();

  static final Uri _base = Uri.parse(
    'https://dataexchange.psweb.pro/api/order.getInformation',
  );

  final String accessToken;
  final String userId;
  final http.Client _client;

  Future<String> getOrderInformation(String orderId) async {
    final uri = _base.replace(
      queryParameters: {
        'access_token': accessToken,
        'orderID': orderId,
        'userID': userId,
      },
    );
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw ApiException(
        'HTTP ${response.statusCode} for orderID=$orderId',
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
