import 'package:flutter/material.dart';
import 'package:glad_tools/tools/url_inspector/url_inspector_tool.dart';
import 'package:glad_tools/views/url_inspector/body_view.dart';
import 'package:glad_tools/views/url_inspector/headers_view.dart';
import 'package:glad_tools/views/url_inspector/status_view.dart';
import 'package:glad_tools/views/main_view.dart';
import 'package:glad_tools/views/tool_widget.dart';
import 'package:http/http.dart';

class UrlInspectorView extends ToolWidget<UrlInspectorTool> {
  const UrlInspectorView({Key? key, required UrlInspectorTool tool})
      : super(
          key: key,
          tool: tool,
        );

  @override
  _UrlInspectorState createState() => _UrlInspectorState();
}

class _UrlInspectorState extends ToolWidgetState<UrlInspectorView, UrlInspectorTool> {
  final TextEditingController _controller = TextEditingController();
  Response? response;

  @override
  void initState() {
    super.initState();
    if (toolObject.input != null) {
      _controller.text = toolObject.input!;
      _parse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TextButton(
              onPressed: _parse,
              child: const Text("Inspect"),
            ),
            TextButton(
              onPressed: _clear,
              child: const Text("Clear"),
            ),
            IconButton(onPressed: copy, icon: const Icon(Icons.copy)),
            IconButton(onPressed: _paste, icon: const Icon(Icons.paste)),
          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - TOP_BAR_HEIGHT,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Enter URL to inspect",
                    ),
                    minLines: 1,
                    controller: _controller,
                  ),
                ),
                if (response != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: StatusView(response: response!),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: HeadersView(response: response!),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BodyView(response: response!),
                        ),
                      ],
                    ),
                  ),
                ],
                if (errorString != null)
                  Text("Error while getting response: $errorString"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _parse() async {
    try {
      response = await toolObject.getResponse(_controller.text);
      toolObject.input = _controller.text;
      errorString = null;
    } catch (e) {
      setState(() {
        errorString = e.toString();
        response = null;
      });
    }
    setState(() {});
  }

  void _clear() {
    super.clear();
    _controller.value = TextEditingValue(
      text: "",
      selection: TextSelection.fromPosition(
        const TextPosition(offset: 0),
      ),
    );
    setState(() {});
  }

  void _paste() async {
    await paste();
    if (toolObject.input != null) {
      _controller.text = toolObject.input!;
      _parse();
    }
  }

  @override
  void showError() {
    // TODO: implement showError
  }
}
