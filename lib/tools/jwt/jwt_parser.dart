
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glad_tools/tools/model/tool_object.dart';
import 'package:glad_tools/views/jwt_parser_view.dart';

class JwtParserTool extends ToolObject {
  JwtParserTool([String? input])
      : super(
          title: "JWT Parser",
          icon: const Icon(Icons.stars_outlined),
          contentBuilder: (context, tool) => JwtParserView(tool: tool as JwtParserTool),
    input: input,
        );

  String decode(String input) {
    final parts = input.split(".");
    if (parts.length != 3) {
      throw "JWT token is invalid";
    }
    String payloadString = parts[1];
    switch (payloadString.length % 4) {
      case 0:
        break;
      case 2:
        payloadString += "==";
        break;
      case 3:
        payloadString += '=';
        break;
      default:
        throw "Invalid format";
    }
    return utf8.decode(base64Decode(input));
  }
}

