import 'package:flutter/material.dart';

abstract class PageBuilder {
  const PageBuilder();

  Widget buildPage(BuildContext context);

  Widget buildIcon(BuildContext context);

  String getTitle();

  Uri getUri();
}
