import 'package:flutter/material.dart';
import 'package:glad_tools/tools/model/tool_object.dart';

const TOP_BAR_HEIGHT = 100.0;

class MainView extends StatefulWidget {
  final List<ToolObject> actions;

  MainView({Key? key, required this.actions})
      : assert(actions.length > 0),
        super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late ToolObject selected;

  @override
  void initState() {
    super.initState();
    selected = widget.actions[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(selected.title),
          actions: widget.actions
              .map(
                (e) => ElevatedButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(selected == e
                          ? Icons.subdirectory_arrow_right
                          : e.icon),
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

  @override
  void dispose() {
    super.dispose();
  }
}
