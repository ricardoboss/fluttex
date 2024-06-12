part of '../../html_parser.dart';

class HtmlHElement extends HtmlElement {
  HtmlHElement({
    required this.level,
    super.attributes,
    super.children,
    super.parent,
  })  : assert(level >= 1),
        assert(level <= 6),
        super(tagName: 'h$level');

  final int level;
}
