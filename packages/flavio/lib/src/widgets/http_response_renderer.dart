part of '../../flavio.dart';

class HttpResponseRenderer extends StatelessWidget {
  const HttpResponseRenderer({
    super.key,
    required this.response,
    required this.responseBody,
  });

  final http.BaseResponse response;
  final StringBuffer responseBody;

  String? get contentType => response.headers['content-type']?.split(';').first;

  @override
  Widget build(BuildContext context) {
    return switch (contentType) {
      'text/html' => _renderHtml(context),
      _ => const Text('Unsupported content type'),
    };
  }

  Widget _renderHtml(BuildContext context) {
    final document = HtmlParser().parse(responseBody.toString());

    return HtmlDocumentRenderer(document: document);
  }
}
