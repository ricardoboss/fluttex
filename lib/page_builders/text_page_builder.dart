import 'package:flutter/material.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:fluttex/page_builders/page_builder.dart';

class TextPageBuilder extends PageBuilder {
  TextPageBuilder({
    required this.text,
    required this.uri,
  });

  final String text;
  final Uri uri;

  @override
  Widget buildPage(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Text(text),
        ],
      ),
    );
  }

  @override
  HeadInformation get head => HeadInformation(
        title: '${text.substring(0, 10).split('\n').first}...',
        iconBuilder: (context) => const Icon(Icons.text_snippet_outlined),
        uri: uri,
      );
}
