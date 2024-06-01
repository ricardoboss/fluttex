import 'package:flutter/material.dart';
import 'package:fluttex/page_builder.dart';

class HomePageBuilder extends PageBuilder {
  const HomePageBuilder();

  @override
  Widget buildIcon(BuildContext context) => const Icon(Icons.home);

  @override
  Widget buildPage(BuildContext context) {
    return const Center(
      child: Text('Navigate to a URL using the search bar above'),
    );
  }

  @override
  String getTitle() => 'Home';

  @override
  Uri getUri() => Uri.parse('fluttex://home');
}
