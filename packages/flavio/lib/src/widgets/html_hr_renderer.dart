part of '../../flavio.dart';

class HtmlHrRenderer extends StatelessWidget {
  const HtmlHrRenderer({
    super.key,
    required this.element,
  });

  final HtmlHrElement element;

  @override
  Widget build(BuildContext context) => const Divider();
}
