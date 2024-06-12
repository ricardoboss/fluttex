part of '../../flavio.dart';

class HtmlInputRenderer extends StatelessWidget {
  const HtmlInputRenderer({
    super.key,
    required this.element,
  });

  final HtmlInputElement element;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: element.attributes['placeholder'],
      ),
    );
  }
}
