part of '../../html_parser.dart';

class HtmlBodyElement extends HtmlElement {
  HtmlBodyElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'body');
}
