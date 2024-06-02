import 'package:flutter/material.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:fluttex/page_builders/page_builder.dart';

class ErrorPageBuilder extends PageBuilder {
  const ErrorPageBuilder({
    required this.error,
    this.uri,
  });

  final Object error;
  final Uri? uri;

  @override
  HeadInformation get head => HeadInformation(
        title: 'Oops!',
        iconBuilder: (context) => const Icon(Icons.error),
        uri: uri ?? Uri.parse('fluttex://error'),
      );

  @override
  Widget buildPage(BuildContext context) => ErrorWidget(error);
}
