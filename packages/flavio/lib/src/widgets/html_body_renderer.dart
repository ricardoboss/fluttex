part of '../../flavio.dart';

class HtmlBodyRenderer extends StatelessWidget {
  const HtmlBodyRenderer({
    super.key,
    required this.element,
  });

  final HtmlBodyElement element;

  @override
  Widget build(BuildContext context) =>
      HtmlNodesRenderer(nodes: element.children);
}
