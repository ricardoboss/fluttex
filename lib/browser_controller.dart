import 'package:flutter/material.dart';

class BrowserController with ChangeNotifier {
  PageBuilder _pageBuilder = const HomePageBuilder();

  PageBuilder getPageBuilder() => _pageBuilder;

  Future<void> load(Uri uri) async {
    _pageBuilder = LoadingPageBuilder(uri: uri);

    notifyListeners();

    // TODO: implement load
    await Future.delayed(const Duration(seconds: 3));

    _pageBuilder = ErrorPageBuilder(error: 'Not implemented', uri: uri);

    notifyListeners();
  }
}

abstract class PageBuilder {
  const PageBuilder();

  Widget buildPage(BuildContext context);

  Widget buildIcon(BuildContext context);

  String getTitle();

  Uri getUri();
}

class HomePageBuilder extends PageBuilder {
  const HomePageBuilder();

  @override
  Widget buildIcon(BuildContext context) => const Icon(Icons.home);

  @override
  Widget buildPage(BuildContext context) => const SizedBox.shrink();

  @override
  String getTitle() => 'Home';

  @override
  Uri getUri() => Uri.parse('fluttex://home');
}

class LoadingPageBuilder extends PageBuilder {
  const LoadingPageBuilder({required this.uri});

  final Uri uri;

  @override
  Widget buildIcon(BuildContext context) => const CircularProgressIndicator();

  @override
  Widget buildPage(BuildContext context) => const SizedBox.shrink();

  @override
  String getTitle() => 'Loading...';

  @override
  Uri getUri() => uri;
}

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
