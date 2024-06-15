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

  final _styleController = StyleController();

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

      Uri uri = Uri.parse(href!);
      if (!uri.isAbsolute) {
        uri = widget.response!.request!.url.resolveUri(uri);
      }

      await _loadStyleSheet(uri);
    }
  }

  Future<void> _loadStyleSheet(Uri uri) async {
    requestBus.fire(ResourceRequest(
      uri: uri,
      fulfill: _onStyleSheetLoaded,
      reject: (e) {
        /* TODO(ricardoboss): handle errors */
      },
      contentTypeHint: MediaType('text', 'css'),
    ));
  }

  Future<void> _onStyleSheetLoaded(http.BaseResponse response) async {
    final css = switch (response) {
      final http.StreamedResponse streamedResponse =>
        await streamedResponse.stream.bytesToString(),
      _ => (response as http.Response).body,
    };

    try {
      final map = const CssParser().parse(css);

      _styleController.addMap(map);
    } catch (e) {
      debugPrint('Error parsing CSS: $e');
    }
  }

  Future<void> _processScripts() async {
    final scriptLinks = widget.document.head?.findAllTags(
          'script',
          (l) => l.attributes['src'] != null,
        ) ??
        <HtmlElement>[];

    for (final link in scriptLinks) {
      final src = link.attributes['src'];

      assert(src != null, 'Script link has no src');

      Uri uri = Uri.parse(src!);
      if (!uri.isAbsolute) {
        uri = widget.response!.request!.url.resolveUri(uri);
      }

      await _loadScript(uri);
    }
  }

  Future<void> _loadScript(Uri uri) async {
    debugPrint('Loading script: $uri');
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
          (l) =>
              [
                'icon',
                'shortcut icon',
                'apple-touch-icon',
              ].contains(l.attributes['rel']) ||
              [
                'ico',
                'png',
                'jpg',
              ].any((ext) => l.attributes['href']?.endsWith(ext) ?? false),
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

      final maybeType = link.attributes['type'];
      final mime = maybeType != null
          ? MediaType.parse(maybeType)
          : guessContentTypeByExtension(
                  uri.pathSegments.last.split('.').last) ??
              MediaType('image', 'png');
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
            styleController: _styleController,
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
