part of '../../common.dart';

class RenderPageEvent extends Event {
  final PageBuilder builder;

  RenderPageEvent(this.builder);

  @override
  String get debug => '$RenderPageEvent -> ${builder.debug}';
}
