part of '../../html_parser.dart';

class HtmlSectionElement extends HtmlElement {
  HtmlSectionElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'section');
}
