import 'package:flutter/material.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:fluttex/page_builders/page_builder.dart';

class HomePageBuilder extends PageBuilder {
  const HomePageBuilder();

  @override
  HeadInformation get head => HeadInformation(
        title: 'Home',
        iconBuilder: (context) => const Icon(Icons.home),
        uri: Uri.parse('fluttex://home'),
      );

  @override
  Widget buildPage(BuildContext context) {
    return const Center(
      child: Text('Navigate to a URL using the search bar above'),
    );
  }
}
