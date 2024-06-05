part of '../../flavio.dart';

class HtmlBodyRenderer extends StatelessWidget {
  const HtmlBodyRenderer({
    super.key,
    required this.body,
  });

  final HtmlElement body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        body.text,
      ),
    );
  }
}
