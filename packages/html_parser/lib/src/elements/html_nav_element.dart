part of '../../html_parser.dart';

class HtmlNavElement extends HtmlElement {
  HtmlNavElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'nav');
}
