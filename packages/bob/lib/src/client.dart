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
    requestBus.fire(ResolveQuery(
      query: request.query,
      fulfill: (url) => _onQueryResolved(request, url),
      reject: (e) => request.reject(e),
    ));
  }

  static final _bussTlds = [];
  static final _bussDnsCache = <String, String>{};

  static Future<void> _loadBussTlds() async {
    if (_bussTlds.isNotEmpty) {
      return;
    }

    final response = await client.get(
      Uri.parse('https://api.buss.lol/tlds'),
      headers: {'Accept': 'application/json'},
    );

    final json = jsonDecode(response.body) as List<dynamic>;

    _bussTlds.addAll(json.cast<String>());
  }

  static Future<(Uri, MediaType?)> _resolveUrl(Uri uri) async {
    await _loadBussTlds();

    final tld = uri.host.split('.').last;

    if (!_bussTlds.contains(tld)) {
      uri = uri.replace(scheme: 'https');

      return (uri, null);
    }

    // TODO: support subdomains
    final name = uri.host.split('.').first;
    final cacheKey = "$name.$tld";

    String target;
    if (_bussDnsCache.containsKey(cacheKey)) {
      target = _bussDnsCache[cacheKey]!;
    } else {
      final response = await _get(
        Uri.parse('https://api.buss.lol/domain/$name/$tld'),
        headers: {'Accept': 'application/json'},
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      target = json['ip'] as String;

      _bussDnsCache[cacheKey] = target;
    }

    final url = Uri.tryParse(target);

    // When the target is an IP address, the path is the same as target
    if (url != null && url.path != target) {
      if (uri.path.isEmpty) {
        uri = uri.replace(path: 'index.html');
      }

      if (url.host == 'github.com') {
        final githubUser = url.pathSegments[0];
        final githubRepo = url.pathSegments[1];

        assert(uri.path.startsWith('/'));
        final originalPath = uri.path.substring(1);

        final rawContentUrl =
            'https://raw.githubusercontent.com/$githubUser/$githubRepo/main/$originalPath';

        final contentTypeGuess = guessContentTypeByExtension(
          originalPath.split('.').last,
        );

        return (Uri.parse(rawContentUrl), contentTypeGuess);
      } else {
        return (url, null);
      }
    }

    final ip = InternetAddress(target);

    return (uri.replace(scheme: 'https', host: ip.address), null);
  }

  static Future<void> _onQueryResolved(
    QueryRequest request,
    Uri url,
  ) async {
    uiBus.fire(UriChangedEvent(url.toString()));

    final (resolvedUrl, expectedMediaType) = await _resolveUrl(url);

    _onDnsResolved(request, resolvedUrl, expectedMediaType);
  }

  static Future<void> _onDnsResolved(
    QueryRequest request,
    Uri uri,
    MediaType? expectedMediaType,
  ) async {
    final http.BaseResponse response;

    try {
      response = await _get(uri);
    } catch (e) {
      request.reject(e);

      return;
    }

    if (expectedMediaType != null &&
        response.headers['content-type'] != expectedMediaType.mimeType) {
      response.headers['content-type'] = expectedMediaType.mimeType;
    }

    request.fulfill(response);
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
