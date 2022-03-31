import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glad_tools/views/json_beautify_view.dart';
import 'package:glad_tools/tools/json_beautify/json_parser_isolate.dart';
import 'package:glad_tools/tools/model/tool_object.dart';

class JsonTool extends ToolObject {
  JsonTool([String? input])
      : super(
          title: "JSON Beautify",
          icon: Icons.format_align_justify,
          contentBuilder: (context, tool) => JsonToolView(tool: tool as JsonTool,),
          input: input,
        );

  @override
  bool isSupportedOnThisPlatform() => !kIsWeb;

  static Future<String> stringToBeautifyString(String text,
      {int withIndent = 4}) async {
    var parser = JsonParserIsolate(text);
    dynamic map = await parser.parseJson();
    return formatObjectToString(map, withIndent);
  }

  static String formatObjectToString(Object map, int indent) {
    var spaces = "";
    while (indent >= 0) {
      indent--;
      spaces += " ";
    }
    var string = JsonEncoder.withIndent(spaces);
    return string.convert(map);
  }

  static Future<String> minifyString(String text) async {
    var parser = JsonParserIsolate(text);
    Object map = await parser.parseJson();
    return _minifyStringInnerHelper(map);
  }

  static String _minifyStringInnerHelper(Object? input) {
    var inner = "";
    if (input is num) {
      inner = input.toString();
    } else if (input is String) {
      inner = "\"${input.toString()}\"";
    } else if (input is bool) {
      inner = input.toString();
    } else if (input is List) {
      inner = "[";
      for (var element in input) {
        inner += _minifyStringInnerHelper(element);
        if (input.last != element) {
          inner += ",";
        }
      }
      inner += "]";
    } else if (input is Map) {
      inner = "{";
      for (var entry in input.entries) {
        inner += "\"${entry.key}\":";

        inner += _minifyStringInnerHelper(entry.value);
        if (input.entries.last.key != entry.key) {
          inner += ",";
        }
      }
      inner += "}";
    } else if (input == null) {
      inner += "null";
    }

    return inner;
  }
}
