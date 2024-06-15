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
  late final Future<Uint8List> bodyFuture;

  @override
  void initState() {
    super.initState();

    bodyFuture = _streamBody();
  }

  Future<Uint8List> _streamBody() async {
    final response = widget.response;

    return await response.stream.toBytes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
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

  Widget _buildBody(Uint8List body) => HttpResponseRenderer(
        response: widget.response,
        responseBody: body,
      );
}
