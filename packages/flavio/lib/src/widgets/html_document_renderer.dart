part of '../../flavio.dart';

class HtmlDocumentRenderer extends StatefulWidget {
  const HtmlDocumentRenderer({
    super.key,
    required this.document,
  });

  final HtmlDocument document;

  @override
  State<HtmlDocumentRenderer> createState() => _HtmlDocumentRendererState();
}

class _HtmlDocumentRendererState extends State<HtmlDocumentRenderer> {
  late final Future<HtmlElement> bodyFuture;

  @override
  void initState() {
    super.initState();

    bodyFuture = _processDocument();
  }

  Future<HtmlElement> _processDocument() async {
    await _processHead();

    final body = widget.document.findFirstElement((n) => n.tagName == 'body');

    if (body == null) {
      return HtmlElement(tagName: 'body');
    }

    return body;
  }

  Future<void> _processHead() async {
    final title =
        widget.document.findFirstElement((n) => n.tagName == 'title')?.text ??
            'Untitled Document';
    uiBus.fire(TitleChangedEvent(title));

    // todo fire event for favicon
    uiBus.fire(
      FaviconChangedEvent(
        (c) => const Icon(Icons.text_snippet_outlined),
      ),
    );

    // todo fire events for resources (style, script)
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HtmlElement>(
      future: bodyFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HtmlBodyRenderer(body: snapshot.requireData);
        }

        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
