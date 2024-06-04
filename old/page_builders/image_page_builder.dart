import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:fluttex/page_builders/page_builder.dart';

class ImagePageBuilder extends PageBuilder {
  ImagePageBuilder({
    required this.uri,
    required this.imageBytes,
  });

  final Uri uri;
  final Uint8List imageBytes;

  @override
  Widget buildPage(BuildContext context) {
    return Center(
      child: Image.memory(
        imageBytes,
      ),
    );
  }

  @override
  HeadInformation get head => HeadInformation(
        title: uri.pathSegments.last,
        iconBuilder: (context) => const Icon(Icons.image),
        uri: uri,
      );
}
