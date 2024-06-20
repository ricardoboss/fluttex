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
    final alignment = _getAlignment(style);
    final gap = _getGap(style);

    return HtmlNodesRenderer(
      nodes: element.children,
      direction: direction.axis,
      alignment: alignment,
      gap: gap,
    );
  }

  static _DivDirection _getDirection(StyleRuleSet rules) {
    final direction = rules['direction']?.text;

    return switch (direction) {
      'row' => _DivDirection.row,
      _ => _DivDirection.column,
    };
  }

  static CrossAxisAlignment _getAlignment(StyleRuleSet rules) {
    final alignment = rules['align-items']?.text;

    return switch (alignment) {
      'start' => CrossAxisAlignment.start,
      'end' => CrossAxisAlignment.end,
      'center' => CrossAxisAlignment.center,
      'stretch' => CrossAxisAlignment.stretch,
      _ => CrossAxisAlignment.stretch,
    };
  }

  static double _getGap(StyleRuleSet rules) {
    final gap = rules['gap'];
    if (gap == null) {
      return 0.0;
    }

    switch (gap) {
      case final CssUnitlessNumber unitlessNumber:
        return unitlessNumber.value.toDouble();
      case final CssNumber number:
        return number.value.toDouble();
      default:
        throw UnimplementedError('Unexpected gap type ${gap.runtimeType}');
    }
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
