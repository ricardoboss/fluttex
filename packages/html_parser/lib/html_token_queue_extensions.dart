import 'dart:collection';

import 'package:html_parser/html_token.dart';
import 'package:html_parser/html_token_type.dart';

extension HtmlTokenQueueExtensions on Queue<HtmlToken> {
  HtmlToken removeToken(HtmlTokenType expected) {
    if (isEmpty) {
      throw Exception('Expected token $expected but queue is empty');
    }

    final token = removeFirst();

    if (token.type != expected) {
      throw Exception('Expected token $expected but got $token');
    }

    return token;
  }

  HtmlTokenType get firstType => first.type;
}
