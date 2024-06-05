part of '../../flavio.dart';

class StreamedResponseBody extends StatefulWidget {
  const StreamedResponseBody({
    super.key,
    required this.response,
  });

  final http.StreamedResponse response;

  @override
  State<StreamedResponseBody> createState() => _StreamedResponseBodyState();
}

class _StreamedResponseBodyState extends State<StreamedResponseBody> {
  late final Future<StringBuffer> bodyFuture;

  @override
  void initState() {
    super.initState();

    bodyFuture = widget.response.stream.transform(utf8.decoder).fold(
          StringBuffer(),
          (StringBuffer buffer, String chunk) => buffer..write(chunk),
        );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StringBuffer>(
      future: bodyFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildBody(snapshot.requireData);
        }

        if (snapshot.hasError) {
          return _buildError(snapshot.error!);
        }

        return _buildLoading();
      },
    );
  }

  Widget _buildError(Object error) => ErrorWidget(error);

  Widget _buildLoading() => const Center(
        child: CircularProgressIndicator(),
      );

  Widget _buildBody(StringBuffer body) => HttpResponseRenderer(
        response: widget.response,
        responseBody: body,
      );
}
