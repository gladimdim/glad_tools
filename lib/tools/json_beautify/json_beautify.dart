import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glad_tools/tools/json_beautify/json_beautify_view.dart';
import 'package:glad_tools/tools/json_beautify/json_parser_isolate.dart';
import 'package:glad_tools/tools/tool_object.dart';

class JsonBeautify extends ToolObject {
  static dynamic rootObject;

  JsonBeautify()
      : super(
          title: "JSON Beautify",
          icon: const Icon(Icons.format_align_justify),
          contentBuilder: (context) => const JsonBeautifyView(),
        );

  static Future<String> stringToBeautifyString(String text,
      {int withIndent = 4}) async {
    var parser = JsonParserIsolate(text);
    dynamic map = await parser.parseJson();
    return formatString(map, withIndent);
  }

  static String formatString(Map<String, dynamic> map, int indent) {
    var spaces = "";
    while (indent >= 0) {
      indent--;
      spaces += " ";
    }
    var string = JsonEncoder.withIndent(spaces);
    return string.convert(map);
  }
}
