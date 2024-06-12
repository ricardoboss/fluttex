part of '../../flavio.dart';

class HtmlARenderer extends StatelessWidget {
  const HtmlARenderer({
    super.key,
    required this.element,
  });

  final HtmlAElement element;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _onTap(context),
      child: HtmlNodesRenderer(nodes: element.children),
    );
  }

  void _onTap(BuildContext context) {
    final href = element.attributes['href'];
    if (href == null) {
      return;
    }

    commandBus.fire(NavigateCommand(href));
  }
}
