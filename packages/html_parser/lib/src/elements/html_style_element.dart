part of '../../html_parser.dart';

class HtmlStyleElement extends HtmlElement {
  HtmlStyleElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'style');
}
