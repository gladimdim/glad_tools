import 'package:flutter/material.dart';
import 'package:glad_tools/tools/model/tool_object.dart';
import 'package:glad_tools/views/components/tool_object_card.dart';

class SmallStartingScreen extends StatelessWidget {
  final List<ToolObject> actions;

  const SmallStartingScreen({Key? key, required this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Glad Tools"),
      ),
      body: GridView.builder(
        itemCount: actions.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, i) => InkWell(
          onTap: () => _onToolTapped(context, actions[i]),
          child: ToolObjectCard(
            tool: actions[i],
          ),
        ),
      ),
    );
  }

  void _onToolTapped(BuildContext context, ToolObject tool) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Material(
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tool.title),
                  Hero(tag: tool.title, child: Icon(tool.icon)),
                ],
              ),
            ),
            body: tool.contentBuilder(
              context,
              tool,
            ),
          ),
        ),
      ),
    );
  }
}
