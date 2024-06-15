part of '../../html_parser.dart';

class HtmlMainElement extends HtmlElement {
  HtmlMainElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'main');
}
