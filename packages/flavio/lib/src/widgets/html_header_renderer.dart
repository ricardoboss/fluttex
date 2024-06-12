part of '../../flavio.dart';

class HtmlHeaderRenderer extends StatelessWidget {
  const HtmlHeaderRenderer({
    required this.element,
    super.key,
  });

  final HtmlHeaderElement element;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: HtmlNodesRenderer(nodes: element.children),
    );
  }
}
