part of '../../flavio.dart';

class HttpResponseRenderer extends StatelessWidget {
  const HttpResponseRenderer({
    super.key,
    required this.response,
    required this.responseBody,
  });

  final http.BaseResponse response;
  final Uint8List responseBody;

  Uri? get requestUri => response.request?.url;

  MediaType? get contentType {
    final contentTypeWithEncoding = response.headers['content-type'];
    if (contentTypeWithEncoding == null) {
      return null;
    }

    final contentType = contentTypeWithEncoding.split(';').first;
    MediaType? mediaType = MediaType.parse(contentType);

    // special handling for raw files served from github
    if (requestUri != null &&
        requestUri!.host == 'raw.githubusercontent.com' &&
        contentType == 'text/plain') {
      mediaType = guessContentTypeByExtension(
        filename.split('.').last,
      );
    }

    return mediaType;
  }

  // TODO(ricardoboss): use encoding from headers
  String get body => utf8.decode(responseBody);

  String get filename => requestUri!.pathSegments.last;

  @override
  Widget build(BuildContext context) {
    return switch (contentType?.type) {
      'text' => switch (contentType?.subtype) {
          'html' => _renderHtml(context),
          'css' => _renderCode(context),
          _ => _renderText(context),
        },
      'application' => switch (contentType?.subtype) {
          'javascript' => _renderCode(context),
          'lua' => _renderCode(context),
          'json' => _renderCode(context),
          _ => _renderUnsupportedContentType(context),
        },
      'image' => _renderImage(context),
      null => _renderText(context),
      _ => _renderUnsupportedContentType(context),
    };
  }

  Widget _renderHtml(BuildContext context) {
    // TODO(ricardoboss): only enable error nodes when dev tools are open
    final document = HtmlParser(emitErrorNodes: true).parse(body);

    return HtmlDocumentRenderer(document: document, response: response);
  }

  Widget _renderText(BuildContext context) {
    return TextDocumentRenderer(text: body);
  }

  Widget _renderUnsupportedContentType(BuildContext context) {
    return UnsupportedContentTypeRenderer(contentType: contentType);
  }

  Widget _renderCode(BuildContext context) {
    return CodeRenderer(
      filename: filename,
      sourceCode: body,
    );
  }

  Widget _renderImage(BuildContext context) {
    return ImageRenderer(
      filename: filename,
      imageBytes: responseBody,
      contentType: contentType,
    );
  }
}
