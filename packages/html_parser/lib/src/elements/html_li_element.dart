part of '../../html_parser.dart';

class HtmlLiElement extends HtmlElement {
  HtmlLiElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'li');
}
