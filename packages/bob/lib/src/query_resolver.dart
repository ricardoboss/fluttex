part of '../bob.dart';

class QueryResolver {
  const QueryResolver._();

  static void register() {
    requestBus.on<ResolveQuery>().listen(_onResolveQuery);
  }

  static Future<void> _onResolveQuery(ResolveQuery event) async {
    final Uri resolvedUri;
    try {
      resolvedUri = await resolve(event.query);
    } catch (e) {
      event.reject(e);

      return;
    }

    event.fulfill(resolvedUri);
  }

  static const _supportedSchemes = <String>{
    'http',
    'https',
    'file',
  };

  static Future<Uri> resolve(String query) async {
    if (!_mightBeDomain(query)) {
      return _openInSearch(query);
    }

    Uri uri = Uri.parse(query);
    if (uri.path == query) {
      uri = Uri.parse('//$query');
    }

    if (uri.scheme.isNotEmpty && !_supportedSchemes.contains(uri.scheme)) {
      return _openInSearch(query);
    }

    if (uri.scheme.isEmpty) {
      uri = uri.replace(scheme: 'https');
    }

    if (uri.path == '/') {
      uri = uri.replace(path: '');
    }

    return uri;
  }

  static bool _mightBeDomain(String query) {
    return query.contains('.');
  }

  static Uri _openInSearch(String query) {
    return Uri.parse('https://google.com/search?q=$query');
  }
}
