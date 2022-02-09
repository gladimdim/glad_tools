import 'package:flutter/material.dart';
import 'package:glad_tools/tools/model/tool_object.dart';

class ToolObjectCard extends StatelessWidget {
  final ToolObject tool;

  const ToolObjectCard({Key? key, required this.tool}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Hero(
            tag: tool.title,
            child: Icon(
              tool.icon,
              size: 64,
            ),
          ),
          Text(
            tool.title,
          ),
        ],
      ),
    );
  }
}
