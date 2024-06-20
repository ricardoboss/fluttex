part of '../../common.dart';

class DispatchBuilderEvent extends Event {
  final PageInformation information;

  DispatchBuilderEvent(this.information);

  @override
  String get debug => '$DispatchBuilderEvent -> ${information.debug}';
}
