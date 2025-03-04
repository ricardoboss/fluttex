part of '../../flavio.dart';

class HtmlNodesRenderer extends StatelessWidget {
  const HtmlNodesRenderer({
    required this.nodes,
    this.direction = Axis.vertical,
    super.key,
    this.alignment = CrossAxisAlignment.start,
    this.spacing = 0.0,
  });

  final List<HtmlNode> nodes;
  final Axis direction;
  final CrossAxisAlignment alignment;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) {
      return const SizedBox.shrink();
    }

    if (nodes.length == 1) {
      return HtmlNodeRenderer.render(nodes.first);
    }

    return Flex(
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      spacing: spacing,
      children: [
        for (final node in nodes.where(
          (n) => n is! HtmlText || n.text.trim().isNotEmpty,
        ))
          HtmlNodeRenderer.render(node),
      ],
    );
  }
}
