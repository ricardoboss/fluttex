part of '../../html_parser.dart';

class HtmlAElement extends HtmlElement {
  HtmlAElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'a');
}
