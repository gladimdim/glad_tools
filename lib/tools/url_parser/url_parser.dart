import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glad_tools/tools/model/tool_object.dart';
import 'package:glad_tools/tools/url_parser/query_list.dart';
import 'package:glad_tools/views/main_view.dart';
import 'package:glad_tools/views/tool_widget.dart';
import 'package:glad_tools/views/url_parser_view.dart';

class UrlParserTool extends ToolObject {
  UrlParserTool([String? input])
      : super(
          title: "URL Tools",
          icon: const Icon(Icons.link),
          contentBuilder: (context, tool) => UrlParserView(tool: tool as UrlParserTool),
          input: input,
        );

  Uri parseString(String input) {
    return Uri.parse(input);
  }
}

