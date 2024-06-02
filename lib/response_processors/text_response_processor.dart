import 'package:fluttex/page_builders/text_page_builder.dart';
import 'package:fluttex/response_processors/response_processor.dart';

class TextResponseProcessor extends ResponseProcessor {
  TextResponseProcessor({required super.response});

  @override
  Future<TextPageBuilder> process() async {
    final text = response.body;

    return TextPageBuilder(
      text: text,
      uri: response.request!.url,
    );
  }
}
