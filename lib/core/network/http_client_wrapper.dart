import 'package:http/http.dart' as http;


class HttpClientWrapper {
  final http.Client client;
  final bool enableLogging;

  HttpClientWrapper({
    required this.client,
    this.enableLogging = true,
  });

  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body}) async {
    if (enableLogging) {
      print('🚀 REQUEST: POST $url');
      print('Headers: $headers');
      print('Body: $body');
    }

    final response = await client.post(url, headers: headers, body: body);

    if (enableLogging) {
      print('📥 RESPONSE: ${response.statusCode}');
      print('Body: ${response.body}');
    }

    return response;
  }
}