part of '../../html_parser.dart';

class HtmlImgElement extends HtmlElement {
  HtmlImgElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'img');
}
