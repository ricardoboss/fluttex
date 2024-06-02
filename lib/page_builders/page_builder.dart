import 'package:flutter/material.dart';
import 'package:fluttex/page_builders/head_information.dart';

abstract class PageBuilder {
  const PageBuilder();

  HeadInformation get head;

  Widget buildPage(BuildContext context);
}
