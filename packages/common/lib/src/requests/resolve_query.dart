part of '../../common.dart';

class ResolveQuery extends Request<Uri> {
  const ResolveQuery({
    required this.query,
    required this.fulfill,
    required this.reject,
  });

  final String query;

  @override
  final FutureOr<void> Function(Uri uri) fulfill;

  @override
  final FutureOr<void> Function(Object? error) reject;
}
