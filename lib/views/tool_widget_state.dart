import 'package:flutter/material.dart';
import 'package:glad_tools/tools/model/tool_object.dart';

class ToolWidget extends StatefulWidget {
  final ToolObject tool;

  const ToolWidget({Key? key, required this.tool}) : super(key: key);

  @override
  ToolWidgetState createState() => ToolWidgetState();
}

class ToolWidgetState<T extends ToolWidget> extends State<T> {
  late ToolObject toolObject;
  String? errorString;
  void showError() {}

  void clear() {
      errorString = null;
      toolObject.input = null;
  }

  @override
  void initState() {
    super.initState();
    toolObject = widget.tool;
  }

  @override
  Widget build(context) {
    return Container();
  }
}