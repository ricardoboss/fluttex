part of '../flavio.dart';

class PlaceholderPageBuilder extends PageBuilder<PlaceholderPageInformation> {
  PlaceholderPageBuilder({
    required this.information,
  });

  @override
  final PlaceholderPageInformation information;

  @override
  Widget buildPage(BuildContext context) {
    return Placeholder(
      child: Center(
        child: Text(
          information.uri.toString(),
        ),
      ),
    );
  }
}
