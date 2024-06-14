part of '../../flavio.dart';

class CodeRenderer extends StatefulWidget {
  const CodeRenderer({
    required this.filename,
    required this.sourceCode,
    super.key,
  });

  final String filename;
  final String sourceCode;

  @override
  State<CodeRenderer> createState() => _CodeRendererState();
}

class _CodeRendererState extends State<CodeRenderer> {
  @override
  void initState() {
    super.initState();

    _updateUi();
  }

  void _updateUi() {
    uiBus.fire(TitleChangedEvent(widget.filename));
    uiBus.fire(FaviconChangedEvent(_buildCodeFavicon));
  }

  Widget _buildCodeFavicon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: const Icon(Icons.code),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.sourceCode);
  }
}
