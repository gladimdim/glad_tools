import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glad_tools/tools/tool_object.dart';
import 'package:glad_tools/tools/url_inspector/body_view.dart';
import 'package:glad_tools/tools/url_inspector/headers_view.dart';
import 'package:glad_tools/tools/url_inspector/status_view.dart';
import 'package:glad_tools/views/main_view.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class UrlInspector extends ToolObject {
  static dynamic rootObject;

  UrlInspector()
      : super(
          icon: const Icon(Icons.link),
          title: "URL Inspector",
          contentBuilder: (context) => const UrlInspectorView(),
        );
}

class UrlInspectorView extends StatefulWidget {
  const UrlInspectorView({Key? key}) : super(key: key);

  @override
  _UrlInspectorState createState() => _UrlInspectorState();
}

class _UrlInspectorState extends State<UrlInspectorView> {
  final TextEditingController _controller = TextEditingController();
  Response? response;
  String? errorString;

  @override
  void initState() {
    super.initState();
    if (UrlInspector.rootObject != null) {
      _controller.text = UrlInspector.rootObject as String;
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
            IconButton(onPressed: _copy, icon: const Icon(Icons.copy)),
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
      response = await http.get(Uri.parse(_controller.text));
      UrlInspector.rootObject = _controller.text;
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
    _controller.value = TextEditingValue(
      text: "",
      selection: TextSelection.fromPosition(
        const TextPosition(offset: 0),
      ),
    );
    errorString = null;
    setState(() {});
  }

  void _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      _controller.text = data.text!;
    }
    _parse();
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: _controller.text));
  }
}
