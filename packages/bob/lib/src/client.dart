part of '../bob.dart';

class Client {
  const Client._();

  static const _userAgent =
      'Fluttex/1.0.0 (+https://github.com/ricardoboss/fluttex) Bob/1.0.0';

  static http.Client? _client;

  static http.Client get client => _client ??= _initClient();

  static http.Client _initClient() {
    return RetryClient(
      http.Client(),
    );
  }

  static Future<http.StreamedResponse> _send(http.BaseRequest request) async {
    return await client.send(request);
  }
}
