part of '../../html_parser.dart';

class HtmlPElement extends HtmlElement {
  HtmlPElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'p');
}
