part of '../../common.dart';

class QueryRequest extends Request<http.BaseResponse> {
  QueryRequest({
    required this.query,
    required this.fulfill,
    required this.reject,
    this.contentTypeHint,
    this.baseUrl,
  });

  final String query;
  final MediaType? contentTypeHint;
  final String? baseUrl;

  @override
  final FutureOr<void> Function(http.BaseResponse response) fulfill;

  @override
  final FutureOr<void> Function(Object? error) reject;
}
