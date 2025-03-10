part of '../../flavio.dart';

class HtmlNodeRenderer {
  const HtmlNodeRenderer._();

  static Widget render(HtmlNode node) {
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
      case final HtmlNoscriptElement noscript:
        return HtmlDivLikeRenderer(element: noscript);
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
      case final HtmlTableElement table:
        return HtmlTableRenderer(table: table);
      case final HtmlStyleElement style:
        try {
          final map = CssParser.parse(style.text);

          var applied = false;
          return Builder(builder: (context) {
            final c = HtmlContext.of(context);

            if (!applied) {
              c.styleController.addMap(map);
              applied = true;
            }

            return SizedBox.shrink();
          });
        } catch (e) {
          return Text(
            'Error parsing CSS: ${e.toString()}',
            style: TextStyle(
              color: Colors.yellow,
              backgroundColor: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      case final HtmlScriptElement script:
        // TODO(ricardoboss): execute script
        return const SizedBox.shrink();
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
          'Unimplemented element: <${element.tagName}>',
          style: TextStyle(
            color: Color(0x88888888),
          ),
        );
      case final HtmlText textNode:
        if (textNode.text.trim().isEmpty) {
          return const SizedBox.shrink();
        }

        return Text(
          textNode.text,
          textAlign: TextAlign.left,
        );
      case final HtmlCommentNode _:
        return const SizedBox.shrink();
      default:
        return Text('Unknown node type: ${node.runtimeType}');
    }
  }
}
