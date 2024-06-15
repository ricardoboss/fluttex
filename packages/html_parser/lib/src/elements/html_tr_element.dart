part of '../../html_parser.dart';

class HtmlTrElement extends HtmlElement {
  HtmlTrElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'tr');
}
