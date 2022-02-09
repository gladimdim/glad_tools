import 'package:flutter/material.dart';
import 'package:glad_tools/views/main_view.dart';
import 'package:glad_tools/tools/base64_image/base64_image_tool.dart';
import 'package:glad_tools/tools/json_beautify/json_tool.dart';
import 'package:glad_tools/tools/jwt/jwt_parser.dart';
import 'package:glad_tools/tools/model/tool_object.dart';
import 'package:glad_tools/tools/url_inspector/url_inspector_tool.dart';
import 'package:glad_tools/tools/url_parser/url_parser.dart';
import 'package:glad_tools/views/starting_view/small.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final List<ToolObject> actions = [
    Base64ImageTool(),
    JsonTool(),
    UrlParserTool(),
    JwtParserTool(),
    UrlInspectorTool(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glad tools',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LayoutBuilder(
        builder: (context, constraints) => constraints.maxWidth < 800 ?  SmallStartingScreen(actions: actions) : MainView(actions: actions),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
