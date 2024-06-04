part of '../../common.dart';

class FaviconChangedEvent extends Event {
  final Widget Function(BuildContext context) faviconBuilder;

  FaviconChangedEvent(this.faviconBuilder);
}
