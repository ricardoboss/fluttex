part of '../../flavio.dart';

class HttpResponseRenderer extends StatelessWidget {
  const HttpResponseRenderer({
    super.key,
    required this.response,
    required this.responseBody,
  });

  final http.BaseResponse response;
  final StringBuffer responseBody;

  MediaType? get contentType {
    final contentTypeWithEncoding = response.headers['content-type'];
    if (contentTypeWithEncoding == null) {
      return null;
    }

    final contentType = contentTypeWithEncoding.split(';').first;

    return MediaType.parse(contentType);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: switch (contentType?.type) {
          'text' => switch (contentType?.subtype) {
            'html' => _renderHtml(context),
            _ => _renderText(context),
          },
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
}
