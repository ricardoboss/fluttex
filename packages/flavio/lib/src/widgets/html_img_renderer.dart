part of '../../flavio.dart';

class HtmlImgRenderer extends StatelessWidget {
  const HtmlImgRenderer({
    super.key,
    required this.element,
  });

  final HtmlImgElement element;

  @override
  Widget build(BuildContext context) {
    final source = element.attributes['src'];
    if (source == null) {
      return Placeholder();
    }

    Uri sourceUri = Uri.parse(source);
    if (!sourceUri.isAbsolute) {
      final htmlContext = HtmlContext.of(context);

      sourceUri = htmlContext.response!.request!.url.resolveUri(sourceUri);
    }

    return Image.network(sourceUri.toString());
  }
}
