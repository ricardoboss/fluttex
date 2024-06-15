part of '../../flavio.dart';

class CodeRenderer extends StatefulWidget {
  const CodeRenderer({
    required this.filename,
    required this.sourceCode,
    super.key,
  });

  final String filename;
  final String sourceCode;

  // TODO(ricardoboss): improve language detection
  String get language => filename.split('.').last;

  int get lineCount => sourceCode.split('\n').length;

  @override
  State<CodeRenderer> createState() => _CodeRendererState();
}

class _CodeRendererState extends State<CodeRenderer> {
  late final Future<Highlighter>? _highlighterInitialized;

  @override
  void initState() {
    super.initState();

    _updateUi();

    _highlighterInitialized = _initializeHighlighter();
  }

  void _updateUi() {
    uiBus.fire(TitleChangedEvent(widget.filename));
    uiBus.fire(FaviconChangedEvent(_buildCodeFavicon));
  }

  static const _additionalLanguagesAssetMap = {
    'lua': 'packages/flavio/lib/src/assets/grammars/lua.json',
    'css': 'packages/flavio/lib/src/assets/grammars/css.json',
  };

  Future<void> _loadAdditionalLanguage(String name, String assetPath) async {
    final json = await rootBundle.loadString(assetPath);

    Highlighter.addLanguage(name, json);
  }

  Future<Highlighter> _initializeHighlighter() async {
    if (_additionalLanguagesAssetMap.containsKey(widget.language)) {
      final assetPath = _additionalLanguagesAssetMap[widget.language]!;

      await _loadAdditionalLanguage(widget.language, assetPath);
    } else {
      await Highlighter.initialize([widget.language]);
    }

    final theme = await HighlighterTheme.loadDarkTheme();

    return Highlighter(
      language: widget.language,
      theme: theme,
    );
  }

  Widget _buildCodeFavicon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: const Icon(Icons.code),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Highlighter>(
      future: _highlighterInitialized,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _renderCode(context, snapshot.requireData);
        }

        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  static const _codeTextStyle = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontFamilyFallback: [
      'Menlo',
      'Cascadia Code',
      'Consolas',
      'monospace',
    ],
    fontSize: 14,
  );

  Widget _renderCode(BuildContext context, Highlighter highlighter) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            _buildLineNumbers(context, highlighter),
            Expanded(
              child: Text.rich(
                highlighter.highlight(widget.sourceCode),
                style: _codeTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineNumbers(BuildContext context, Highlighter highlighter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < widget.lineCount; i++)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  '${i + 1}',
                  style: _codeTextStyle.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
