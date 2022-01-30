import 'package:flutter/material.dart';
import 'package:glad_tools/tools/base64_image/base64_image.dart';
import 'package:glad_tools/tools/json_beautify/json_tools.dart';
import 'package:glad_tools/tools/tool_object.dart';
import 'package:glad_tools/tools/jwt/jwt_parser.dart';
import 'package:glad_tools/tools/url_inspector/url_inspector.dart';
import 'package:glad_tools/tools/url_parser/url_parser.dart';

const TOP_BAR_HEIGHT = 100.0;

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<ToolObject> actions = [
    Base64Image(),
    JsonTools(),
    UrlParser(),
    JwtParser(),
    UrlInspector(),
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
                  child: Row(
                    children: [
                      selected == e
                          ? const Icon(Icons.subdirectory_arrow_right)
                          : e.icon,
                      selected == e ? Text(
                        e.title,
                        style: TextStyle(
                          fontWeight: selected == e
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ) : Container(),
                    ],
                  ),
                  onPressed: () => _selected(e),
                ),
              )
              .toList(),
        ),
        body: selected.contentBuilder(context));
  }

  void _selected(ToolObject element) {
    setState(() {
      selected = element;
    });
  }
}
