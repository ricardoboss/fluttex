part of '../../common.dart';

class TitleChangedEvent extends Event {
  final String title;

  const TitleChangedEvent(this.title);

  @override
  String get debug => '$TitleChangedEvent -> $title';
}
