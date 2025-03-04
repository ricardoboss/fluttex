part of '../../html_parser.dart';

class HtmlMetaElement extends HtmlElement {
  HtmlMetaElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'meta');
}
