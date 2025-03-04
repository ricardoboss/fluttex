part of '../../html_parser.dart';

class HtmlNoscriptElement extends HtmlElement {
  HtmlNoscriptElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'noscript');
}
