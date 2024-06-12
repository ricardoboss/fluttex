part of '../../html_parser.dart';

class HtmlOlElement extends HtmlElement {
  HtmlOlElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'ol');
}
