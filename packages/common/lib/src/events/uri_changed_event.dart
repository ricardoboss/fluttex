part of '../../common.dart';

class UriChangedEvent extends Event {
  final String uri;

  const UriChangedEvent(this.uri);

  @override
  String get debug => '$UriChangedEvent -> $uri';
}
