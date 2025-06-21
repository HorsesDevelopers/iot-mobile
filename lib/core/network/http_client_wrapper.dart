import 'package:http/http.dart' as http;

class HttpClientWrapper extends http.BaseClient {
  final http.Client _client;
  final bool enableLogging;

  HttpClientWrapper({
    required http.Client client,
    this.enableLogging = true,
  }) : _client = client;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (enableLogging) {
      print('🚀 REQUEST: ${request.method} ${request.url}');
      print('Headers: ${request.headers}');
      if (request is http.Request) {
        print('Body: ${request.body}');
      }
    }

    final response = await _client.send(request);

    if (enableLogging) {
      print('📥 RESPONSE: ${response.statusCode}');
    }

    return response;
  }

  @override
  void close() {
    _client.close();
    super.close();
  }
}