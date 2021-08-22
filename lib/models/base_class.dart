import 'package:flutter/material.dart';

abstract class ToolObject {
  final Icon icon;
  final WidgetBuilder contentBuilder;

  const ToolObject({required this.icon, required this.contentBuilder});
}
