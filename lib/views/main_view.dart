import 'package:flutter/material.dart';
import 'package:glad_tools/tools/base64_image/base64_image_tool.dart';
import 'package:glad_tools/tools/json_beautify/json_tool.dart';
import 'package:glad_tools/tools/model/tool_object.dart';
import 'package:glad_tools/tools/jwt/jwt_parser.dart';
import 'package:glad_tools/tools/url_inspector/url_inspector_tool.dart';
import 'package:glad_tools/tools/url_parser/url_parser.dart';

const TOP_BAR_HEIGHT = 100.0;

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<ToolObject> actions = [
    Base64ImageTool(),
    JsonTool(),
    UrlParserTool(),
    JwtParserTool(),
    UrlInspectorTool(),
  ];

  late ToolObject selected = actions[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(selected.title),
          actions: actions
              .map(
                (e) => ElevatedButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      selected == e
                          ? const Icon(Icons.subdirectory_arrow_right)
                          : e.icon,
                      Text(
                        e.title,
                        style: TextStyle(
                            fontWeight: selected == e
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: selected == e ? 18 : 12),
                      ),
                    ],
                  ),
                  onPressed: () => _selected(e),
                ),
              )
              .toList(),
        ),
        body: selected.contentBuilder(context, selected));
  }

  void _selected(ToolObject element) {
    setState(() {
      selected = element;
    });
  }
}
