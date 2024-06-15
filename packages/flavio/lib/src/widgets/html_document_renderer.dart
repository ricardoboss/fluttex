part of '../../flavio.dart';

class HtmlDocumentRenderer extends StatefulWidget {
  const HtmlDocumentRenderer({
    super.key,
    required this.document,
    required this.response,
  });

  final HtmlDocument document;
  final http.BaseResponse? response;

  @override
  State<HtmlDocumentRenderer> createState() => _HtmlDocumentRendererState();
}

class _HtmlDocumentRendererState extends State<HtmlDocumentRenderer> {
  late final Future<HtmlBodyElement> bodyFuture;

  @override
  void initState() {
    super.initState();

    bodyFuture = Future.delayed(
      const Duration(milliseconds: 200),
      _processDocument,
    );
  }

  Future<HtmlBodyElement> _processDocument() async {
    await _processHead();

    return widget.document.body ?? HtmlBodyElement();
  }

  Future<void> _processHead() async {
    final title = _getTitle(widget.document);
    uiBus.fire(TitleChangedEvent(title));

    final Widget favicon;
    final faviconUrl = _getFaviconUri(widget.document);
    if (faviconUrl != null) {
      favicon = Image.network(faviconUrl.toString());
    } else {
      favicon = const Icon(Icons.text_snippet_outlined);
    }
    uiBus.fire(FaviconChangedEvent((c) => favicon));

    await _processStyleSheets();

    // don't block rendering for scripts
    unawaited(_processScripts());
  }

  Future<void> _processStyleSheets() async {
    final styleSheetLinks = widget.document.head?.findAllTags(
          'link',
          (l) => l.attributes['href']?.endsWith('.css') ?? false,
        ) ??
        <HtmlElement>[];

    for (final link in styleSheetLinks) {
      final href = link.attributes['href'];

      assert(href != null, 'Style sheet link has no href');

      debugPrint('Loading style sheet: $href');
    }
  }

  Future<void> _processScripts() async {
    // TODO(ricardoboss): implement
  }

  String _getTitle(HtmlDocument document) {
    final title =
        document.head?.findFirstTag('title')?.text ?? 'Untitled Document';

    return title;
  }

  Uri? _getFaviconUri(HtmlDocument document) {
    final available = <(MediaType, Uri)>[];

    for (final link in document.head?.findAllTags(
          'link',
          (l) => [
            'icon',
            'shortcut icon',
            'apple-touch-icon',
          ].contains(l.attributes['rel']),
        ) ??
        <HtmlElement>[]) {
      final href = link.attributes['href'];
      if (href == null) {
        continue;
      }

      Uri uri = Uri.parse(href);
      if (!uri.isAbsolute) {
        uri = widget.response!.request!.url.resolveUri(uri);
      }

      final mime = MediaType.parse(link.attributes['type'] ?? '');
      if (mime.type != 'image') {
        continue;
      }

      available.add((mime, uri));
    }

    return available.firstOrNull?.$2;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: HtmlContextWidget(
          context: HtmlContext(
            document: widget.document,
            response: widget.response,
          ),
          child: FutureBuilder<HtmlBodyElement>(
            future: bodyFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HtmlBodyRenderer(element: snapshot.requireData);
              }

              if (snapshot.hasError) {
                return ErrorWidget(snapshot.error!);
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
