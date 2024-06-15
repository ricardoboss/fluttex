part of '../../html_parser.dart';

class HtmlThElement extends HtmlElement {
  HtmlThElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'th');
}
