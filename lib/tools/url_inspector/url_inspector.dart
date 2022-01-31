import 'package:flutter/material.dart';
import 'package:glad_tools/tools/model/tool_object.dart';
import 'package:glad_tools/views/url_inspector/url_inspector_view.dart';

class UrlInspector extends ToolObject {
  UrlInspector([String? input])
      : super(
    icon: const Icon(Icons.search_sharp),
    title: "URL Inspector",
    contentBuilder: (context, tool) => UrlInspectorView(tool: tool),
    input: input,
  );
}