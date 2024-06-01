import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttex/error_page_builder.dart';
import 'package:fluttex/home_page_builder.dart';
import 'package:fluttex/html_page_builder.dart';
import 'package:fluttex/loading_page_builder.dart';
import 'package:fluttex/page_builder.dart';
import 'package:http/http.dart' as http;

class BrowserController with ChangeNotifier {
  PageBuilder _pageBuilder = const HomePageBuilder();

  PageBuilder getPageBuilder() => _pageBuilder;

  Future<void> reload() async => await navigateTo(uri: _pageBuilder.getUri());

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
        final source = await loadFile(uri: uri);

        return HtmlPageBuilder.fromSource(
          uri: uri,
          source: source,
          controller: this,
        );
      } catch (e) {
        return ErrorPageBuilder(error: e, uri: uri);
      }
    }
  }

  Future<String> loadFile({required Uri uri}) async {
    if (uri.scheme.isEmpty) {
      uri = Uri.parse('buss://$uri');
    }

    return switch (uri.scheme) {
      'http' => loadHttpFile(uri: uri),
      'https' => loadHttpFile(uri: uri),
      'buss' => loadBussFile(uri: uri),
      'file' => loadLocalFile(uri: uri),
      _ => throw UnsupportedError('Unsupported scheme: ${uri.scheme}'),
    };
  }

  Future<String> loadHttpFile({required Uri uri}) async {
    assert(
      ['http', 'https'].contains(uri.scheme),
      'Unsupported scheme: ${uri.scheme}',
    );

    final response = await _get(uri, headers: {'Accept': 'text/html'});

    return response.body;
  }

  final _bussTlds = [];

  Future<String> loadBussFile({required Uri uri}) async {
    await _loadBussTlds();

    final resolvedUri = await _resolveBussUrl(uri);

    if (resolvedUri.host == 'github.com') {
      final requestedFile = uri.path.isEmpty ? 'index.html' : uri.path;
      final username = resolvedUri.pathSegments.first;
      final repo = resolvedUri.pathSegments.last;

      // convert to raw.githubusercontent.com url
      uri = Uri.parse(
        'https://raw.githubusercontent.com/$username/$repo/main/$requestedFile',
      );
    }

    final response = await _get(uri, headers: {'Accept': 'text/html'});

    return response.body;
  }

  final _bussDnsCache = <String, String>{};

  Future<Uri> _resolveBussUrl(Uri uri) async {
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

  Future<String> loadLocalFile({required Uri uri}) async {
    assert(
      ['file'].contains(uri.scheme),
      'Unsupported scheme: ${uri.scheme}',
    );

    final file = File(uri.path);

    return await file.readAsString();
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
