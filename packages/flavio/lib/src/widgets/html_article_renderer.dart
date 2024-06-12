part of '../../flavio.dart';

class HtmlArticleRenderer extends StatelessWidget {
  const HtmlArticleRenderer({
    required this.element,
    super.key,
  });

  final HtmlArticleElement element;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: HtmlNodesRenderer(nodes: element.children),
    );
  }
}
