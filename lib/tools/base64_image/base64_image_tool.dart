import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glad_tools/views/base64_image_decoder_view.dart';
import 'package:glad_tools/tools/model/tool_object.dart';

class Base64ImageTool extends ToolObject {
  Base64ImageTool([String? input])
      : super(
          title: "Base64 Image Decoder",
          icon: Icons.image,
          contentBuilder: (context, tool) => Base64ImageDecoderView(
            tool: tool as Base64ImageTool,
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
