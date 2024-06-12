part of '../../flavio.dart';

class HtmlFooterRenderer extends StatelessWidget {
  const HtmlFooterRenderer({
    required this.element,
    super.key,
  });

  final HtmlFooterElement element;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: HtmlNodesRenderer(nodes: element.children),
    );
  }
}
