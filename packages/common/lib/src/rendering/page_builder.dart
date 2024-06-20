part of '../../common.dart';

abstract class PageBuilder<T extends PageInformation> {
  const PageBuilder();

  String get debug => '$runtimeType';

  T get information;

  Widget buildPage(BuildContext context);
}
