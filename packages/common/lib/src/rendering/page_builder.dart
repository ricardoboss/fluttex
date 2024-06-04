part of '../../common.dart';

abstract class PageBuilder<T extends PageInformation> {
  const PageBuilder();

  T get information;

  Widget buildPage(BuildContext context);
}
