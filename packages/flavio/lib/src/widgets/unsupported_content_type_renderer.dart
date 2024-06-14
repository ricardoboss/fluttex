part of '../../flavio.dart';

class UnsupportedContentTypeRenderer extends StatefulWidget {
  const UnsupportedContentTypeRenderer({super.key, this.contentType});

  final MediaType? contentType;

  @override
  State<UnsupportedContentTypeRenderer> createState() => _UnsupportedContentTypeRendererState();
}

class _UnsupportedContentTypeRendererState extends State<UnsupportedContentTypeRenderer> {
  @override
  void initState() {
    super.initState();

    _updateUi();
  }

  void _updateUi() {
    uiBus.fire(TitleChangedEvent('Unsupported'));
    uiBus.fire(FaviconChangedEvent(_buildUnsupportedContentTypeFavicon));
  }

  Widget _buildUnsupportedContentTypeFavicon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: const Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text('Unsupported content type: ${widget.contentType}');
  }
}
