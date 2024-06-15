part of '../../flavio.dart';

class HttpResponseRenderer extends StatelessWidget {
  const HttpResponseRenderer({
    super.key,
    required this.response,
    required this.responseBody,
  });

  final http.BaseResponse response;
  final StringBuffer responseBody;

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
        requestUri!.pathSegments.last.split('.').last,
      );
    }

    return mediaType;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: switch (contentType?.type) {
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
          null => _renderText(context),
          _ => _renderUnsupportedContentType(context),
        },
      ),
    );
  }

  Widget _renderHtml(BuildContext context) {
    final document = HtmlParser().parse(responseBody.toString());

    return HtmlDocumentRenderer(document: document, response: response);
  }

  Widget _renderText(BuildContext context) {
    return TextDocumentRenderer(text: responseBody.toString());
  }

  Widget _renderUnsupportedContentType(BuildContext context) {
    return UnsupportedContentTypeRenderer(contentType: contentType);
  }

  Widget _renderCode(BuildContext context) {
    return CodeRenderer(
      filename: requestUri!.pathSegments.last,
      sourceCode: responseBody.toString(),
    );
  }
}
