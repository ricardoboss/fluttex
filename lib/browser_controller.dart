import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttex/page_builders/error_page_builder.dart';
import 'package:fluttex/page_builders/home_page_builder.dart';
import 'package:fluttex/page_builders/loading_page_builder.dart';
import 'package:fluttex/page_builders/page_builder.dart';
import 'package:fluttex/response_processors/html_response_processor.dart';
import 'package:fluttex/response_processors/image_response_processor.dart';
import 'package:fluttex/response_processors/response_processor.dart';
import 'package:fluttex/response_processors/text_response_processor.dart';
import 'package:fluttex/response_processors/webx_response_processor.dart';
import 'package:http/http.dart' as http;

class BrowserController with ChangeNotifier {
  PageBuilder _pageBuilder = const HomePageBuilder();

  PageBuilder getPageBuilder() => _pageBuilder;

  Future<void> reload() async => await navigateTo(uri: _pageBuilder.head.uri);

  Future<void> navigateTo({required Uri uri}) async {
    _pageBuilder = LoadingPageBuilder(uri: uri);

    notifyListeners();

    _pageBuilder = await loadPage(uri: uri);

    notifyListeners();
  }

  static const _userAgent =
      'Fluttex/1.0 (+https://github.com/ricardoboss/fluttex)';

  Future<PageBuilder> loadPage({required Uri uri}) async {
    if (uri.scheme == 'fluttex') {
      return loadInternal(uri: uri);
    } else {
      try {
        final processor = await loadFile(uri: uri);

        return processor.process();
      } catch (e) {
        return ErrorPageBuilder(error: e, uri: uri);
      }
    }
  }

  final List<String> _supportedResponseTypes = [
    'text/html',
    'application/json',
    'application/lua',
    'application/dart',
    'application/javascript',
    'text/css',
    'text/javascript',
    'text/plain',
    'image/svg+xml',
    'image/webp',
    'image/bmp',
    'image/png',
    'image/jpeg',
    'image/gif',
  ];

  String get _supportedTypesAcceptHeader => _supportedResponseTypes.join(',');

  Future<ResponseProcessor> loadFile({required Uri uri}) async {
    if (uri.scheme.isEmpty) {
      uri = Uri.parse('buss://$uri');
    }

    if (uri.scheme == 'file') {
      return getLocalFileProcessor(uri: uri);
    }

    if (uri.scheme == 'buss') {
      return getBussResponseProcessor(uri: uri);
    }

    return getHttpResponseProcessor(uri: uri);
  }

  Future<WebXResponseProcessor> getBussResponseProcessor({required Uri uri}) async {
    assert(
      ['buss'].contains(uri.scheme),
      'Unsupported scheme: ${uri.scheme}',
    );

    final response = await getBussResponse(uri: uri);

    return WebXResponseProcessor(
      requestedUri: uri,
      response: response,
      controller: this,
    );
  }

  Future<ResponseProcessor> getHttpResponseProcessor({required Uri uri}) async {
    assert(
      ['http', 'https'].contains(uri.scheme),
      'Unsupported scheme: ${uri.scheme}',
    );

    final response = await getHttpResponse(uri: uri);

    final responseType = response.headers['content-type']?.split(';').first;
    if (responseType == null) {
      throw Exception('No content-type header');
    }

    return switch (responseType) {
      'text/html' => HtmlResponseProcessor(
        response: response,
        controller: this,
      ),
      _ when responseType.startsWith('text/') => TextResponseProcessor(
        response: response,
      ),
      _ when responseType.startsWith('image/') => ImageResponseProcessor(
        response: response,
      ),
      _ => throw Exception('Unsupported response type: $responseType'),
    };
  }

  Future<http.Response> getHttpResponse({required Uri uri}) async {
    assert(
      ['http', 'https'].contains(uri.scheme),
      'Unsupported scheme: ${uri.scheme}',
    );

    return await _get(uri, headers: {'Accept': _supportedTypesAcceptHeader});
  }

  final _bussTlds = [];

  Future<http.Response> getBussResponse({required Uri uri}) async {
    final resolvedUri = await resolveBussUrl(uri);

    if (resolvedUri.host == 'github.com') {
      final requestedFile = uri.path.isEmpty ? 'index.html' : uri.path;
      final username = resolvedUri.pathSegments.first;
      final repo = resolvedUri.pathSegments.last;

      // convert to raw.githubusercontent.com url
      uri = Uri.parse(
        'https://raw.githubusercontent.com/$username/$repo/main/$requestedFile',
      );
    }

    return await _get(uri, headers: {'Accept': _supportedTypesAcceptHeader});
  }

  final _bussDnsCache = <String, String>{};

  Future<Uri> resolveBussUrl(Uri uri) async {
    await _loadBussTlds();

    final tld = uri.host.split('.').last;

    if (!_bussTlds.contains(tld)) {
      throw Exception(
          'The TLD "$tld" is not supported. Supported TLDs: ${_bussTlds.join(', ')}');
    }

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

    final maybeGitHubUri = Uri.tryParse(target);
    if (maybeGitHubUri != null) {
      assert(maybeGitHubUri.host == 'github.com');

      return maybeGitHubUri;
    }

    final ip = InternetAddress(target);

    return uri.replace(host: ip.address);
  }

  Future<void> _loadBussTlds() async {
    if (_bussTlds.isNotEmpty) {
      return;
    }

    final response = await _get(
      Uri.parse('https://api.buss.lol/tlds'),
      headers: {'Accept': 'application/json'},
    );

    final json = jsonDecode(response.body) as List<dynamic>;

    _bussTlds.addAll(json.cast<String>());
  }

  Future<http.Response> _get(Uri uri, {Map<String, String>? headers}) async {
    final response = await http.get(
      uri,
      headers: {
        ...headers ?? {},
        'User-Agent': _userAgent,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('HTTP error ${response.statusCode}');
    }

    return response;
  }

  Future<ResponseProcessor> getLocalFileProcessor({required Uri uri}) async {
    assert(
      ['file'].contains(uri.scheme),
      'Unsupported scheme: ${uri.scheme}',
    );

    final file = File(uri.path);
    // final content = await file.readAsString();

    throw UnimplementedError('Not implemented');
  }

  Future<PageBuilder> loadInternal({required Uri uri}) async {
    assert(
      ['fluttex'].contains(uri.scheme),
      'Unsupported scheme: ${uri.scheme}',
    );

    switch (uri.host) {
      case 'home':
        return const HomePageBuilder();
      case 'loading':
        return LoadingPageBuilder(uri: uri);
      case 'error':
        return ErrorPageBuilder(error: 'Some Error', uri: uri);
      default:
        return ErrorPageBuilder(error: 'Not found', uri: uri);
    }
  }
}
