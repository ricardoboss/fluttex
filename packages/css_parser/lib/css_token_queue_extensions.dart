import 'dart:collection';

import 'package:css_parser/css_token.dart';
import 'package:css_parser/css_token_type.dart';

extension CssTokenQueueExtensions on Queue<CssToken> {
  CssToken removeToken(CssTokenType expected, {bool skipWhitespace = true}) {
    if (isEmpty) {
      throw Exception('Expected token $expected but queue is empty');
    }

    CssToken token;
    do {
      token = removeFirst();
    } while (skipWhitespace && token.type == CssTokenType.whitespace);

    if (token.type != expected) {
      throw Exception('Expected token $expected but got $token');
    }

    return token;
  }

  CssTokenType get firstTypeNoWhitespace {
    if (isEmpty) {
      throw Exception('Queue is empty');
    }

    CssTokenType type;
    int skip = 0;
    do {
      type = elementAt(skip).type;
    } while (length > ++skip && type == CssTokenType.whitespace);

    return type;
  }
}
