part of '../../flavio.dart';

class HtmlHRenderer extends StatelessWidget {
  const HtmlHRenderer({
    required this.element,
    super.key,
  });

  final HtmlHElement element;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: _getFontSize(element),
      ),
      child: HtmlNodesRenderer(nodes: element.children),
    );
  }

  static double _getFontSize(HtmlHElement element) {
    const defaultFontSize = 16.0;

    return switch (element.level) {
      1 => 2 * defaultFontSize,
      2 => 1.5 * defaultFontSize,
      3 => 1.17 * defaultFontSize,
      4 => 1.0 * defaultFontSize,
      5 => 0.83 * defaultFontSize,
      6 => 0.67 * defaultFontSize,
      _ => throw ArgumentError('Invalid level: ${element.level}'),
    };
  }
}
