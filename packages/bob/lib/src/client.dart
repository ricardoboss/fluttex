part of '../bob.dart';

class Client {
  const Client._();

  static void register() {
    requestBus.on<QueryRequest>().listen(_onQueryRequest);
    requestBus.on<ResourceRequest>().listen(_onResourceRequest);
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
    requestBus.fire(ResolveQuery(
      query: request.query,
      fulfill: (url) => _onQueryResolved(request, url),
      reject: (e) => request.reject(e),
    ));
  }

  static Future<(Uri, MediaType?)> _resolveUrl(Uri uri) async {
    uri = uri.replace(scheme: 'https');

    return (uri, null);
  }

  static Future<void> _onQueryResolved(
    QueryRequest request,
    Uri url,
  ) async {
    uiBus.fire(UriChangedEvent(url.toString()));

    final (resolvedUrl, expectedMediaType) = await _resolveUrl(url);

    await _onDnsResolved(request, resolvedUrl, expectedMediaType);
  }

  static Future<void> _onResourceRequest(ResourceRequest request) async {
    await _onDnsResolved(request, request.uri, request.contentTypeHint);
  }

  static Future<void> _onDnsResolved(
    Request<http.BaseResponse> request,
    Uri uri,
    MediaType? expectedMediaType,
  ) async {
    final http.BaseResponse response;

    try {
      response = await _get(uri);
    } catch (e) {
      await request.reject(e);

      return;
    }

    if (expectedMediaType != null &&
        response.headers['content-type'] != expectedMediaType.mimeType) {
      response.headers['content-type'] = expectedMediaType.mimeType;
    }

    await request.fulfill(response);
  }

  static Future<http.Response> _get(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    return await client.get(
      uri,
      headers: {
        ...?headers,
        'User-Agent': _userAgent,
      },
    );
  }
}
