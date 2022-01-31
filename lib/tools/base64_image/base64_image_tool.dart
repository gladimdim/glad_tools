import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glad_tools/tools/base64_image/base64_content_view.dart';
import 'package:glad_tools/tools/model/tool_object.dart';

class Base64ImageTool extends ToolObject {
  Base64ImageTool([String? input])
      : super(
          title: "Base64 Image Decoder",
          icon: const Icon(Icons.image),
          contentBuilder: (context, tool) => Base64ImageContent(
            tool: tool,
          ),
          input: input,
        );

  static Image stringToImage(String input) {
    final content = getContent(input);
    Uint8List bytes = base64Decode(content);
    return Image.memory(
      bytes,
    );
  }

  static String getContent(String input) {
    final containsMeta = input.contains("data:image");
    if (containsMeta) {
      input = input.split(",")[1];
    }
    return input;
  }
}
