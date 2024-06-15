part of '../../flavio.dart';

class HtmlDivLikeRenderer extends StatelessWidget {
  const HtmlDivLikeRenderer({
    required this.element,
    super.key,
  });

  final HtmlElement element;

  @override
  Widget build(BuildContext context) {
    assert((() {
      return [
        'div',
        'main',
        'nav',
        'article',
        'header',
        'footer',
        'section',
      ].contains(element.tagName);
    })());

    return Align(
      alignment: Alignment.topLeft,
      child: HtmlNodesRenderer(nodes: element.children),
    );
  }
}
