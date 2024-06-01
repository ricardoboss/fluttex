import 'package:flutter/material.dart';
import 'package:fluttex/page_builder.dart';

class ErrorPageBuilder extends PageBuilder {
  const ErrorPageBuilder({required this.error, this.uri});

  final Uri? uri;
  final Object error;

  @override
  Widget buildIcon(BuildContext context) => const Icon(Icons.error);

  @override
  Widget buildPage(BuildContext context) {
    return ErrorWidget(error);
  }

  @override
  String getTitle() => 'Oops!';

  @override
  Uri getUri() => uri ?? Uri.parse('fluttex://error');
}
