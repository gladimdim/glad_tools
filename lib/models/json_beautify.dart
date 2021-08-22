import 'package:flutter/material.dart';
import 'package:glad_tools/models/base_class.dart';

class JsonBeautify extends ToolObject {
  JsonBeautify()
      : super(
          icon: const Icon(Icons.format_align_justify),
          contentBuilder: (context) => const Text("321"),
        );
}
