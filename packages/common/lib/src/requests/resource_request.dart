part of '../../common.dart';

class ResourceRequest extends Request<http.BaseResponse> {
  const ResourceRequest({
    required this.uri,
    required this.fulfill,
    required this.reject,
    this.contentTypeHint,
  });

  final Uri uri;
  final MediaType? contentTypeHint;

  @override
  final FutureOr<void> Function(http.BaseResponse response) fulfill;

  @override
  final FutureOr<void> Function(Object? error) reject;
}
