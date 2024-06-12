part of '../../html_parser.dart';

class HtmlHeadElement extends HtmlElement {
  HtmlHeadElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'head');
}
