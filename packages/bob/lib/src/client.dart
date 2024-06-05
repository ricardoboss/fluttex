part of '../bob.dart';

class Client {
  const Client._();

  static void register() {
    requestBus.on<QueryRequest>().listen(_onQueryRequest);
  }

  static const _userAgent =
      'Fluttex/1.0.0 (+https://github.com/ricardoboss/fluttex) Bob/1.0.0';

  static http.Client? _client;

  static http.Client get client => _client ??= _initClient();

  static http.Client _initClient() {
    return RetryClient(
      http.Client(),
    );
  }

  static void _onQueryRequest(QueryRequest request) {
    requestBus.fire(ResolveUrlRequest(
      query: request.query,
      fulfill: (url) => _onUrlResolved(request, url),
      reject: (e) => request.reject(e),
    ));
  }

  static Future<void> _onUrlResolved(
    QueryRequest request,
    Uri uri,
  ) async {
    try {
      final httpRequest = http.Request('GET', uri);
      httpRequest.headers['User-Agent'] = _userAgent;

      final response = await client.send(httpRequest);

      request.fulfill(response);
    } catch (e) {
      request.reject(e);
    }
  }
}
