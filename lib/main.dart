import 'package:flutter/material.dart';
import 'package:fluttex/fluttex_app.dart';
import 'package:smith/smith.dart';
import 'package:flavio/flavio.dart';
import 'package:bob/bob.dart';

void main() {
  CommandHandler().register();
  PageBuilderRegistry.register();
  UrlResolver.register();

  runApp(const FluttexApp());
}
