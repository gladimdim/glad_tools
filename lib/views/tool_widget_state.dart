import 'package:flutter/material.dart';
import 'package:glad_tools/tools/model/tool_object.dart';

abstract class ToolWidgetState<T extends StatefulWidget> extends State<T> {
  late ToolObject toolObject;
  String? errorString;
  void showError();

  void clear() {
      errorString = null;
      toolObject.input = null;
  }
}