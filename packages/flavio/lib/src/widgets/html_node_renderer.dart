part of '../../flavio.dart';

class HtmlNodeRenderer extends StatelessWidget {
  const HtmlNodeRenderer({
    required this.node,
    super.key,
  });

  final HtmlNode node;

  @override
  Widget build(BuildContext context) {
    switch (node) {
      case final HtmlBodyElement body:
        return HtmlBodyRenderer(element: body);
      case final HtmlDivElement div:
        return HtmlDivRenderer(element: div);
      case final HtmlHrElement hr:
        return HtmlHrRenderer(element: hr);
      case final HtmlHElement h:
        return HtmlHRenderer(element: h);
      case final HtmlPElement p:
        return HtmlPRenderer(element: p);
      case final HtmlInputElement input:
        return HtmlInputRenderer(element: input);
      case final HtmlImgElement img:
        return HtmlImgRenderer(element: img);
      case final HtmlButtonElement button:
        return HtmlButtonRenderer(element: button);
      case final HtmlAElement a:
        return HtmlARenderer(element: a);
      case final HtmlHeaderElement header:
        return HtmlHeaderRenderer(element: header);
      case final HtmlArticleElement article:
        return HtmlArticleRenderer(element: article);
      case final HtmlFooterElement footer:
        return HtmlFooterRenderer(element: footer);
      case final HtmlErrorNode errorNode:
        return ErrorWidget(errorNode.message);
      case final HtmlElement element:
        return Text('Unimplemented element: ${element.tagName}');
      case final HtmlText textNode:
        if (textNode.text.trim().isEmpty) {
          return const SizedBox.shrink();
        }

        return Text(textNode.text);
      case final HtmlCommentNode _:
        return const SizedBox.shrink();
      default:
        return Text('Unknown node type: ${node.runtimeType}');
    }
  }
}
