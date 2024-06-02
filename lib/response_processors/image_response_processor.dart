import 'package:fluttex/page_builders/image_page_builder.dart';
import 'package:fluttex/response_processors/response_processor.dart';

class ImageResponseProcessor extends ResponseProcessor {
  ImageResponseProcessor({required super.response});

  @override
  Future<ImagePageBuilder> process() async {
    final imageBytes = response.bodyBytes;

    return ImagePageBuilder(
      uri: response.request!.url,
      imageBytes: imageBytes,
    );
  }
}
