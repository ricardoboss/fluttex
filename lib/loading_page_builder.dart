import 'package:flutter/material.dart';
import 'package:fluttex/page_builder.dart';

class LoadingPageBuilder extends PageBuilder {
  const LoadingPageBuilder({required this.uri});

  final Uri uri;

  @override
  Widget buildIcon(BuildContext context) => const Padding(
    padding: EdgeInsets.all(16.0),
    child: CircularProgressIndicator(),
  );

  @override
  Widget buildPage(BuildContext context) => const SizedBox.shrink();

  @override
  String getTitle() => 'Loading...';

  @override
  Uri getUri() => uri;
}
