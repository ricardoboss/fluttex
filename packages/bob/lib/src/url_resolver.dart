part of '../bob.dart';

class UrlResolver {
  const UrlResolver._();

  static void register() {
    requestBus.on<ResolveUrlRequest>().listen(_onResolveUrl);
  }

  static Future<void> _onResolveUrl(ResolveUrlRequest event) async {
    try {
      final resolvedUri = await resolve(event.query);

      event.fulfill(resolvedUri);
    } catch (e) {
      event.reject(e);
    }
  }

  static Future<Uri> resolve(String query) async {
    // TODO actual lookup

    return Uri.parse(query);
  }
}
