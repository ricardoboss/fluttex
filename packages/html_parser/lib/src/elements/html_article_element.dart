part of '../../html_parser.dart';

class HtmlArticleElement extends HtmlElement {
  HtmlArticleElement({
    super.attributes,
    super.children,
    super.parent,
  }) : super(tagName: 'article');
}
