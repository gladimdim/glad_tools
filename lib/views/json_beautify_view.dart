import 'package:flutter/material.dart';
import 'package:glad_tools/components/ui/bordered_all.dart';
import 'package:glad_tools/tools/json_beautify/json_tool.dart';
import 'package:glad_tools/utils/clipboard_manager.dart';
import 'package:glad_tools/views/tool_widget_state.dart';

class JsonToolView extends ToolWidget<JsonTool> {
  const JsonToolView({Key? key, required JsonTool tool})
      : super(
          key: key,
          tool: tool,
        );

  @override
  _JsonToolViewState createState() => _JsonToolViewState();
}

class _JsonToolViewState extends ToolWidgetState<JsonToolView, JsonTool> {
  final Key errorKey = const Key("errorText");
  final TextEditingController _controller = TextEditingController();
  int _whitespaceAmount = 2;

  @override
  void initState() {
    super.initState();
    if (toolObject.input != null) {
      _controller.text = toolObject.input!;
      _format();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TextButton(
              onPressed: _format,
              child: const Text("Beautify"),
            ),
            const Text("Spaces: "),
            DropdownButton(
              onChanged: _whitespaceAmountChanged,
              value: _whitespaceAmount,
              items: [2, 4, 8].map((e) {
                return DropdownMenuItem<int>(
                    value: e, child: Text(e.toString()));
              }).toList(),
            ),
            TextButton(
              onPressed: _minify,
              child: const Text("Minify"),
            ),
            TextButton(
              onPressed: _clear,
              child: const Text("Clear"),
            ),
            IconButton(onPressed: copy, icon: const Icon(Icons.copy)),
            IconButton(onPressed: _paste, icon: const Icon(Icons.paste)),
          ],
        ),
        SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BorderedAll(
                    color: errorString == null ? Colors.black : Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Paste JSON to process",
                        ),
                        minLines: 5,
                        maxLines: (MediaQuery.of(context).size.height ~/ 30),
                        controller: _controller,
                      ),
                    ),
                  ),
                ),
              ),
              if (errorString != null)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(errorString!, key: errorKey),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _clear() {
    super.clear();
    setState(() {
      _controller.value = TextEditingValue(
        text: "",
        selection: TextSelection.fromPosition(
          const TextPosition(offset: 0),
        ),
      );
      errorString = null;
      toolObject.input = null;
    });
  }

  void _paste() async {
    await paste();
    if (toolObject.input != null) {
      _controller.text = toolObject.input!;
      _format();
    }
  }

  void _format() async {
    toolObject.input = _controller.text;

    errorString = null;
    if (_controller.text.isEmpty) {
      return;
    }

    try {
      final result = await JsonTool.stringToBeautifyString(_controller.text,
          withIndent: _whitespaceAmount);
      setState(() {
        _controller.text = result;
      });
    } catch (e) {
      reportError(e);
    }
  }

  void _minify() async {
    if (_controller.text.isEmpty) {
      return;
    }
    try {
      final minified = await JsonTool.minifyString(_controller.text);
      setState(() {
        _controller.text = minified;
      });
    } catch (e) {
      reportError(e);
    }
  }

  void reportError(Object e) {
    setState(() {
      errorString = "Error while parsing JSON: ${e.toString()}";
    });
  }

  void _whitespaceAmountChanged(int? value) {
    setState(() {
      int newValue = value ?? 2;

      _whitespaceAmount = newValue;
      _format();
    });
  }

  @override
  void showError() {
    // TODO: implement showError
  }
}
