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
        return HtmlDivLikeRenderer(element: div);
      case final HtmlMainElement main:
        return HtmlDivLikeRenderer(element: main);
      case final HtmlNavElement nav:
        return HtmlDivLikeRenderer(element: nav);
      case final HtmlSectionElement section:
        return HtmlDivLikeRenderer(element: section);
      case final HtmlHeaderElement header:
        return HtmlDivLikeRenderer(element: header);
      case final HtmlFooterElement footer:
        return HtmlDivLikeRenderer(element: footer);
      case final HtmlArticleElement article:
        return HtmlDivLikeRenderer(element: article);
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
      case final HtmlBrElement br:
        return HtmlBrRenderer(element: br);
      case final HtmlUlElement ul:
        return HtmlListRenderer(element: ul);
      case final HtmlOlElement ol:
        return HtmlListRenderer(element: ol);
      case final HtmlErrorNode errorNode:
        return Text(
          errorNode.message,
          style: TextStyle(
            color: Colors.yellow,
            backgroundColor: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        );
      case final HtmlElement element:
        return Text(
          'Unimplemented element: ${element.tagName}',
          style: TextStyle(
            color: Color(0x88888888),
          ),
        );
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
