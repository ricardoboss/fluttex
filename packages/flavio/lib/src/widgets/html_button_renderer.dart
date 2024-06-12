part of '../../flavio.dart';

class HtmlButtonRenderer extends StatelessWidget {
  const HtmlButtonRenderer({
    super.key,
    required this.element,
  });

  final HtmlButtonElement element;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: HtmlNodesRenderer(nodes: element.children),
    );
  }
}
