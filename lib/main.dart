import 'package:bob/bob.dart' as bob;
import 'package:common/common.dart';
import 'package:flavio/flavio.dart' as flavio;
import 'package:flutter/material.dart';
import 'package:fluttex/fluttex_app.dart';
import 'package:smith/smith.dart' as smith;

void main() {
  smith.CommandHandler.register();
  flavio.PageBuilderRegistry.register();
  bob.QueryResolver.register();
  bob.Client.register();

  commandBus.on<Firable>().listen((event) {
    debugPrint('commandBus: ${event.debug}');
  });

  requestBus.on<Firable>().listen((event) {
    debugPrint('requestBus: ${event.debug}');
  });

  uiBus.on<Firable>().listen((event) {
    debugPrint('uiBus: ${event.debug}');
  });

  runApp(const FluttexApp());
}
