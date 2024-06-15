part of '../../flavio.dart';

class TextDocumentRenderer extends StatefulWidget {
  const TextDocumentRenderer({
    required this.text,
    super.key,
  });

  final String text;

  @override
  State<TextDocumentRenderer> createState() => _TextDocumentRendererState();
}

class _TextDocumentRendererState extends State<TextDocumentRenderer> {
  @override
  void initState() {
    super.initState();

    _updateUi();
  }

  void _updateUi() {
    uiBus.fire(TitleChangedEvent('Text Document'));
    uiBus.fire(FaviconChangedEvent(_buildTextFavicon));
  }

  Widget _buildTextFavicon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: const Icon(Icons.text_snippet_outlined),
    );
  }

  @override
  Widget build(BuildContext context) => Text(
        style: TextStyle(
          fontFamily: 'JetBrains Mono',
          fontFamilyFallback: [
            'Menlo',
            'Consolas',
            'monospace',
          ],
          fontSize: 14,
        ),
        widget.text,
      );
}
