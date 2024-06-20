part of '../../flavio.dart';

class HtmlListRenderer extends StatelessWidget {
  const HtmlListRenderer({
    required this.element,
    super.key,
  });

  final HtmlElement element;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < element.children.length; i++)
          _renderChildNode(context, element.children[i], i, 0),
      ],
    );
  }

  Widget _renderChildNode(
      BuildContext context, HtmlNode node, int index, int level) {
    if (node case final HtmlLiElement li) {
      return _renderListItem(context, li, index, level);
    }

    return HtmlNodeRenderer.render(node);
  }

  Widget _renderListItem(
      BuildContext context, HtmlLiElement li, int index, int level) {
    return Row(
      children: [
        _bullet(context, index, level),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < li.children.length; i++)
              _renderChildNode(context, li.children[i], i, level + 1),
          ],
        ),
      ],
    );
  }

  Widget _bullet(BuildContext context, int index, int level) {
    return Container(
      width: level * 16,
      height: 16,
      child: Text(
        index.toString(),
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }
}
