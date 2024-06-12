part of '../../html_parser.dart';

class HtmlInputElement extends HtmlElement {
  HtmlInputElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'input');
}
