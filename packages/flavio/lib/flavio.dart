library flavio;

import 'dart:async';
import 'dart:convert';

import 'package:common/common.dart';
import 'package:css_parser/css_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html_parser/html_parser.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:css_parser/css_map.dart';
import 'package:css_parser/style_context.dart';
import 'package:smith/smith.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

part 'src/error_page_builder.dart';
part 'src/html_context.dart';
part 'src/http_response_page_builder.dart';
part 'src/page_builder_registry.dart';
part 'src/placeholder_page_builder.dart';
part 'src/style_controller.dart';
part 'src/widgets/code_renderer.dart';
part 'src/widgets/html_a_renderer.dart';
part 'src/widgets/html_body_renderer.dart';
part 'src/widgets/html_br_renderer.dart';
part 'src/widgets/html_button_renderer.dart';
part 'src/widgets/html_context_widget.dart';
part 'src/widgets/html_div_like_renderer.dart';
part 'src/widgets/html_document_renderer.dart';
part 'src/widgets/html_h_renderer.dart';
part 'src/widgets/html_hr_renderer.dart';
part 'src/widgets/html_img_renderer.dart';
part 'src/widgets/html_input_renderer.dart';
part 'src/widgets/html_list_renderer.dart';
part 'src/widgets/html_node_renderer.dart';
part 'src/widgets/html_nodes_renderer.dart';
part 'src/widgets/html_p_renderer.dart';
part 'src/widgets/html_table_renderer.dart';
part 'src/widgets/http_response_renderer.dart';
part 'src/widgets/style_resolver.dart';
part 'src/widgets/image_renderer.dart';
part 'src/widgets/streamed_response_body.dart';
part 'src/widgets/text_document_renderer.dart';
part 'src/widgets/unsupported_content_type_renderer.dart';
