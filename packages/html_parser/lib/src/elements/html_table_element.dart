part of '../../html_parser.dart';

class HtmlTableElement extends HtmlElement {
  HtmlTableElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'table');
}
