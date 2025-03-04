part of '../../html_parser.dart';

class HtmlScriptElement extends HtmlElement {
  HtmlScriptElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'script');
}
