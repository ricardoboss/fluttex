part of '../../common.dart';

class NavigateCommand extends Command {
  const NavigateCommand(this.query);

  final String query;

  @override
  String get debug => '$NavigateCommand -> $query';
}
