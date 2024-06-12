part of '../../html_parser.dart';

class HtmlHeaderElement extends HtmlElement {
  HtmlHeaderElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'header');
}
