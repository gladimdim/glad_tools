import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glad_tools/tools/json_beautify/json_beautify_view.dart';
import 'package:glad_tools/tools/json_beautify/json_parser_isolate.dart';
import 'package:glad_tools/tools/tool_object.dart';

class JsonTools extends ToolObject {
  static dynamic rootObject;

  JsonTools()
      : super(
          title: "JSON Beautify",
          icon: const Icon(Icons.format_align_justify),
          contentBuilder: (context) => const JsonBeautifyView(),
        );

  static Future<String> stringToBeautifyString(String text,
      {int withIndent = 4}) async {
    var parser = JsonParserIsolate(text);
    dynamic map = await parser.parseJson();
    return formatMapToString(map, withIndent);
  }

  static String formatMapToString(Map<String, dynamic> map, int indent) {
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
    Map<String, dynamic> map = await parser.parseJson();
    return _minifyString(map);
  }

  static String _minifyString(Object? input) {
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
        inner += _minifyString(element);
        if (input.last != element) {
          inner += ",";
        }
      }
      inner += "]";
    } else if (input is Map) {
      inner = "{";
      for (var entry in input.entries) {
        inner += "\"${entry.key}\":";

        inner += _minifyString(entry.value);
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
