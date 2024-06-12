part of '../../flavio.dart';

class HtmlDivRenderer extends StatelessWidget {
  const HtmlDivRenderer({
    required this.element,
    super.key,
  });

  final HtmlDivElement element;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: HtmlNodesRenderer(nodes: element.children),
    );
  }
}
