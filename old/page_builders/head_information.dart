import 'package:flutter/material.dart';

class HeadInformation {
  const HeadInformation({
    required this.title,
    required this.iconBuilder,
    required this.uri,
  });

  final String title;
  final Widget Function(BuildContext context) iconBuilder;
  final Uri uri;
}
