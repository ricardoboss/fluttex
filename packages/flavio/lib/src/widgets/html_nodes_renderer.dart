part of '../../flavio.dart';

class HtmlNodesRenderer extends StatelessWidget {
  const HtmlNodesRenderer({
    required this.nodes,
    this.direction = Axis.vertical,
    super.key,
    this.alignment = CrossAxisAlignment.start,
    this.gap = 0.0,
  });

  final List<HtmlNode> nodes;
  final Axis direction;
  final CrossAxisAlignment alignment;
  final double gap;

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) {
      return const SizedBox.shrink();
    }

    if (nodes.length == 1) {
      return HtmlNodeRenderer.render(nodes.first);
    }

    Widget Function(HtmlNode node) renderer = HtmlNodeRenderer.render;
    if (gap > 0) {
      renderer = (node) {
        final insets = switch (direction) {
          Axis.vertical => EdgeInsets.symmetric(vertical: gap / 2.0),
          Axis.horizontal => EdgeInsets.symmetric(horizontal: gap / 2.0),
        };

        return Padding(
          padding: insets,
          child: HtmlNodeRenderer.render(node),
        );
      };
    }

    return Flex(
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: [
        for (final node
            in nodes.where((n) => n is! HtmlText || n.text.trim().isNotEmpty))
          renderer(node),
      ],
    );
  }
}
