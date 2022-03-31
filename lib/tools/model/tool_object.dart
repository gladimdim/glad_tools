import 'dart:io';

import 'package:flutter/material.dart';

typedef WidgetToolBuilder = Widget Function(
    BuildContext context, ToolObject tool);

abstract class ToolObject {
  final IconData icon;
  final WidgetToolBuilder contentBuilder;
  final String title;
  String? input;
  bool isSupportedOnThisPlatform();

  ToolObject({
    required this.icon,
    required this.contentBuilder,
    required this.title,
    this.input,
  });
}
