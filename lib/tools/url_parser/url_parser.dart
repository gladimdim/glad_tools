import 'package:flutter/material.dart';
import 'package:glad_tools/tools/model/tool_object.dart';
import 'package:glad_tools/views/url_parser_view.dart';

class UrlParserTool extends ToolObject {
  UrlParserTool([String? input])
      : super(
          title: "URL Tools",
          icon: Icons.link,
          contentBuilder: (context, tool) => UrlParserView(tool: tool as UrlParserTool),
          input: input,
        );

  Uri parseString(String input) {
    return Uri.parse(input);
  }
}

