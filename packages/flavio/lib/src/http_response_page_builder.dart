part of '../flavio.dart';

class HttpResponsePageBuilder extends PageBuilder<HttpResponsePageInformation> {
  HttpResponsePageBuilder({
    required this.information,
  });

  @override
  final HttpResponsePageInformation information;

  @override
  Widget buildPage(BuildContext context) {
    return switch (information.response) {
      http.StreamedResponse streamedResponse =>
        _buildStreamedResponse(context, streamedResponse),
      http.Response response => _buildResponse(context, response),
      _ => ErrorWidget(
          UnimplementedError('Unsupported response type'),
        ),
    };
  }

  Widget _buildStreamedResponse(
    BuildContext context,
    http.StreamedResponse response,
  ) =>
      StreamedResponseBody(response: response);

  Widget _buildResponse(BuildContext context, http.Response response) {
    return HttpResponseRenderer(
      response: response,
      responseBody: response.bodyBytes,
    );
  }
}
