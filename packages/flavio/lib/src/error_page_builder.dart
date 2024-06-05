part of '../flavio.dart';

class ErrorPageBuilder extends PageBuilder<ErrorPageInformation> {
  const ErrorPageBuilder({
    required this.information,
  });

  @override
  final ErrorPageInformation information;

  @override
  Widget buildPage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            information.code,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
