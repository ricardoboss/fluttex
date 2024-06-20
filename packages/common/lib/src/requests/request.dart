part of '../../common.dart';

abstract class Request<T> extends Firable {
  const Request();

  FutureOr<void> Function(T response) get fulfill;

  FutureOr<void> Function(Object? error) get reject;
}
