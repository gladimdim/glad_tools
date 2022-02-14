import 'package:flutter/material.dart';
import 'package:glad_tools/tools/base64_image/base64_image_tool.dart';
import 'package:glad_tools/tools/model/tool_object.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton<T extends ToolObject> extends StatelessWidget {
  final T tool;

  const ShareButton({Key? key, required this.tool}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: _onPress, icon: const Icon(Icons.share));
  }

  void _onPress() {
    var input = tool.input;
    if (input != null) {
      switch (T) {
        case Base64ImageTool:
          _exportImage(input);
          break;
        default:
          _exportString(input);
          break;
      }
    }
  }

  Future _exportImage(String input) async {

  }

  Future _exportString(String input) async {
    await Share.share(input);
  }
}
