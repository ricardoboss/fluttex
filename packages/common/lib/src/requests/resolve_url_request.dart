part of '../../common.dart';

class ResolveUrlRequest extends Request<Uri> {
  const ResolveUrlRequest({
    required this.query,
    required this.fulfill,
    required this.reject,
  });

  final String query;

  @override
  final FutureOr<void> Function(Uri response) fulfill;

  @override
  final FutureOr<void> Function(Object? error) reject;
}
