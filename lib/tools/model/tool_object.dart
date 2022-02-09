import 'package:flutter/material.dart';

typedef WidgetToolBuilder = Widget Function(
    BuildContext context, ToolObject tool);

abstract class ToolObject {
  final IconData icon;
  final WidgetToolBuilder contentBuilder;
  final String title;
  String? input;

  ToolObject({
    required this.icon,
    required this.contentBuilder,
    required this.title,
    this.input,
  });
}
