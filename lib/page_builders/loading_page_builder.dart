import 'package:flutter/material.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:fluttex/page_builders/page_builder.dart';

class LoadingPageBuilder extends PageBuilder {
  const LoadingPageBuilder({required this.uri});

  final Uri uri;

  @override
  Widget buildPage(BuildContext context) => const SizedBox.shrink();

  @override
  HeadInformation get head => HeadInformation(
        title: 'Loading...',
        iconBuilder: (context) => const Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
        uri: uri,
      );
}
