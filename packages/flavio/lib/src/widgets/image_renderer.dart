part of '../../flavio.dart';

class ImageRenderer extends StatefulWidget {
  const ImageRenderer({
    required this.filename,
    required this.imageBytes,
    super.key,
    this.contentType,
  });

  final String filename;
  final Uint8List imageBytes;
  final MediaType? contentType;

  @override
  State<ImageRenderer> createState() => _ImageRendererState();
}

class _ImageRendererState extends State<ImageRenderer> {
  @override
  void initState() {
    super.initState();

    _updateUi();
  }

  void _updateUi() {
    uiBus.fire(TitleChangedEvent(widget.filename));
    uiBus.fire(FaviconChangedEvent(_buildImageFavicon));
  }

  Widget _buildImageFavicon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: const Icon(Icons.image),
    );
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.contentType?.type) {
      'image' => switch (widget.contentType?.subtype) {
          'svg' => _buildSvg(context),
          _ => _buildBitmap(context),
        },
      null => _buildBitmap(context),
      _ => _buildUnsupportedContentType(context),
    };
  }

  Widget _buildBitmap(BuildContext context) {
    return Image.memory(widget.imageBytes);
  }

  Widget _buildSvg(BuildContext context) {
    return SvgPicture.memory(widget.imageBytes);
  }

  Widget _buildUnsupportedContentType(BuildContext context) {
    return Center(
      child: Text('Unsupported content type: ${widget.contentType}'),
    );
  }
}
