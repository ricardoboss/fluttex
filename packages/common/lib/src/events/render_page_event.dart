part of '../../common.dart';

class RenderPageEvent extends Event {
  final PageBuilder builder;

  RenderPageEvent(this.builder);
}
