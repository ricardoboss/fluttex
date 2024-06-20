part of '../../flavio.dart';

class HtmlBodyRenderer extends StatelessWidget with StyleResolver {
  const HtmlBodyRenderer({
    super.key,
    required this.element,
  });

  final HtmlBodyElement element;

  @override
  Widget build(BuildContext context) {
    final style = resolveStyle(context, element);

    final backgroundColorProp = style['background-color'] as CssColor?;
    final paddingProp = style['padding'] as CssNumber?;
    final borderRadiusProp = style['border-radius'] as CssNumber?;

    final backgroundColor =
        backgroundColorProp != null ? Color(backgroundColorProp.color) : null;
    final padding = paddingProp != null
        ? EdgeInsets.all(paddingProp.value.toDouble())
        : null;
    final borderRadius = borderRadiusProp != null
        ? BorderRadius.circular(borderRadiusProp.value.toDouble())
        : null;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: HtmlNodesRenderer(
        nodes: element.children,
      ),
    );
  }
}
