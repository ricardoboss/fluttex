part of '../../flavio.dart';

class HtmlNodesRenderer extends StatelessWidget {
  const HtmlNodesRenderer({
    required this.nodes,
    this.direction = Axis.vertical,
    super.key,
  });

  final List<HtmlNode> nodes;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) {
      return const SizedBox.shrink();
    }

    if (nodes.length == 1) {
      return HtmlNodeRenderer(node: nodes.first);
    }

    return Flex(
      direction: direction,
      children: [
        for (final node in nodes)
          HtmlNodeRenderer(node: node),
      ],
    );
  }
}
