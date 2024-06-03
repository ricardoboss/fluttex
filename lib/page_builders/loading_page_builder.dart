import 'package:flutter/material.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:fluttex/page_builders/page_builder.dart';

class LoadingPageBuilder extends PageBuilder {
  const LoadingPageBuilder({required this.uri});

  final Uri uri;

  @override
  Widget buildPage(BuildContext context) => Center(
    child: Text(
      'Loading...',
      style: Theme.of(context).textTheme.headlineMedium,
    ),
  );

  @override
  HeadInformation get head => HeadInformation(
        title: 'Loading...',
        iconBuilder: (c) => _buildLoader(c, 4),
        uri: uri,
      );

  Widget _buildLoader(BuildContext context, double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: const CircularProgressIndicator(
        strokeWidth: 6,
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
