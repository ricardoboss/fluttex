part of '../../common.dart';

class HttpRequest extends Request<http.BaseResponse> {
  HttpRequest({
    required this.request,
    required this.fulfill,
    required this.reject,
  });

  final http.BaseRequest request;

  @override
  final FutureOr<void> Function(http.BaseResponse response) fulfill;

  @override
  final FutureOr<void> Function(Object? error) reject;
}
