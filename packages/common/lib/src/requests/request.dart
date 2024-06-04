part of '../../common.dart';

abstract class Request<T> {
  const Request();

  FutureOr<void> Function(T response) get fulfill;

  FutureOr<void> Function(Object? error) get reject;
}
