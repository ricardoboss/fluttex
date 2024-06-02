import 'package:fluttex/page_builders/page_builder.dart';
import 'package:http/http.dart' as http;

abstract class ResponseProcessor {
  const ResponseProcessor({
    required this.response,
  });

  final http.Response response;

  Future<PageBuilder> process();
}
