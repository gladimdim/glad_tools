import 'package:flutter/material.dart';
import 'package:glad_tools/tools/model/tool_object.dart';
import 'package:glad_tools/utils/clipboard_manager.dart';

class ToolWidget<V extends ToolObject> extends StatefulWidget {
  final V tool;

  const ToolWidget({Key? key, required this.tool}) : super(key: key);

  @override
  ToolWidgetState createState() => ToolWidgetState();
}

class ToolWidgetState<T extends ToolWidget, V extends ToolObject> extends State<T> {
  late V toolObject;
  String? errorString;
  void showError() {}

  void clear() {
      errorString = null;
      toolObject.input = null;
  }

  @override
  void initState() {
    super.initState();
    toolObject = widget.tool as V;
  }

  void copy() {
    final input = toolObject.input;
    if (input != null) {
      ClipboardManager.copy(input);
    }
  }

  Future paste() async {
    final data = await ClipboardManager.paste();
    if (data != null) {
      toolObject.input = data;
    }
  }

  @override
  Widget build(context) {
    return Container();
  }
}