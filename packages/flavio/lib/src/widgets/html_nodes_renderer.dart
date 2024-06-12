part of '../../flavio.dart';

class HtmlNodesRenderer extends StatelessWidget {
  const HtmlNodesRenderer({
    required this.nodes,
    super.key,
  });

  final List<HtmlNode> nodes;

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) {
      return const SizedBox.shrink();
    }

    if (nodes.length == 1) {
      return HtmlNodeRenderer(node: nodes.first);
    }

    return Column(
      children: [
        for (final node in nodes)
          HtmlNodeRenderer(node: node),
      ],
    );
  }
}
