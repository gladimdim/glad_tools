import 'package:flutter/material.dart';
import 'package:glad_tools/tools/model/tool_object.dart';
import 'package:glad_tools/views/url_inspector/url_inspector_view.dart';
import 'package:http/http.dart' as http;

class UrlInspector extends ToolObject {
  UrlInspector([String? input])
      : super(
    icon: const Icon(Icons.search_sharp),
    title: "URL Inspector",
    contentBuilder: (context, tool) => UrlInspectorView(tool: tool as UrlInspector),
    input: input,
  );

  Future<http.Response> getResponse(String url) async {
    return  await http.get(Uri.parse(url));
  }
}