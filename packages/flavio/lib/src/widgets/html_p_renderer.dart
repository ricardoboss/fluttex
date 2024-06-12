part of '../../flavio.dart';

class HtmlPRenderer extends StatelessWidget {
  const HtmlPRenderer({
    super.key,
    required this.element,
  });

  final HtmlPElement element;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: HtmlNodesRenderer(nodes: element.children),
    );
  }
}
