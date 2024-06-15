part of '../../flavio.dart';

class HtmlDivLikeRenderer extends StatelessWidget with StyleResolver {
  const HtmlDivLikeRenderer({
    required this.element,
    super.key,
  });

  final HtmlElement element;

  @override
  Widget build(BuildContext context) {
    assert((() {
      return [
        'div',
        'main',
        'nav',
        'article',
        'header',
        'footer',
        'section',
      ].contains(element.tagName);
    })());

    final style = resolveStyle(context, element);

    final direction = _getDirection(style);

    return Align(
      alignment: Alignment.topLeft,
      child: HtmlNodesRenderer(
        direction: direction.axis,
        nodes: element.children,
      ),
    );
  }

  static _DivDirection _getDirection(StyleRuleSet rules) {
    final direction = rules['direction']?.text;

    return switch (direction) {
      'row' => _DivDirection.row,
      _ => _DivDirection.column,
    };
  }
}

enum _DivDirection {
  column,
  row;

  Axis get axis {
    switch (this) {
      case column:
        return Axis.vertical;
      case row:
        return Axis.horizontal;
    }
  }
}
