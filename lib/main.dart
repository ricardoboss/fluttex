import 'package:bob/bob.dart' as bob;
import 'package:flavio/flavio.dart' as flavio;
import 'package:flutter/material.dart';
import 'package:fluttex/fluttex_app.dart';
import 'package:smith/smith.dart' as smith;

void main() {
  smith.CommandHandler().register();
  flavio.PageBuilderRegistry.register();
  bob.UrlResolver.register();
  bob.Client.register();

  runApp(const FluttexApp());
}
