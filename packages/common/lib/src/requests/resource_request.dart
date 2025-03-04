part of '../../common.dart';

class ResourceRequest extends Request<http.BaseResponse> {
  const ResourceRequest({
    required this.uri,
    required this.fulfill,
    required this.reject,
    this.accept,
  });

  final Uri uri;
  final Iterable<MediaType>? accept;

  @override
  final FutureOr<void> Function(http.BaseResponse response) fulfill;

  @override
  final FutureOr<void> Function(Object? error) reject;

  @override
  String get debug =>
      '$ResourceRequest -> $uri (${accept?.toString() ?? '???'})';
}
