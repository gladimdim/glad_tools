import 'package:flutter/material.dart';

abstract class ToolObject {
  final Icon icon;
  final WidgetBuilder contentBuilder;
  final String title;
  static dynamic rootObject;

   ToolObject({
    required this.icon,
    required this.contentBuilder,
    required this.title,
  });
}
