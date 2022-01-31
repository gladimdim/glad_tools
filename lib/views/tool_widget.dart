import 'package:flutter/material.dart';
import 'package:glad_tools/tools/tool_object.dart';

class ToolWidget extends StatefulWidget {
  final Type toolObject;
  const ToolWidget({Key? key, required this.toolObject}) : super(key: key);

  @override
  _ToolWidgetState createState() => _ToolWidgetState();
}

class _ToolWidgetState extends State<ToolWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

abstract class ToolWidgetState<T extends StatefulWidget> extends State<T> {
  ToolObject? toolObject;
  String? errorString;
  void showError();

  void clear() {
      errorString = null;
  }
}