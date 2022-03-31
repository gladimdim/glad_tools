import 'package:glad_tools/tools/url_parser/url_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glad_tools/views/url_parser_view/query_list_view.dart';
import 'package:glad_tools/views/main_view.dart';
import 'package:glad_tools/views/tool_widget.dart';

class UrlParserView extends ToolWidget<UrlParserTool> {
  const UrlParserView({
    Key? key,
    required UrlParserTool tool,
  }) : super(key: key, tool: tool);

  @override
  _Base64ImageContentState createState() => _Base64ImageContentState();
}

class _Base64ImageContentState
    extends ToolWidgetState<UrlParserView, UrlParserTool> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _pathController = TextEditingController();
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _schemeController = TextEditingController();
  final TextEditingController _fragmentController = TextEditingController();
  Uri? uri;

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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            TextButton(
              onPressed: _parse,
              child: const Text("Parse"),
            ),
            TextButton(
              onPressed: _clear,
              child: const Text("Clear"),
            ),
            TextButton(onPressed: _decodeUrl, child: const Text("Decode")),
            TextButton(onPressed: _encodeUrl, child: const Text("Encode")),
            IconButton(onPressed: copy, icon: const Icon(Icons.copy)),
            IconButton(onPressed: _paste, icon: const Icon(Icons.paste)),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Paste URL to process",
                      label: Text("Full URL"),
                    ),
                    controller: _controller,
                    onSubmitted: (_) => _parse(),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration:
                              const InputDecoration(label: Text("Scheme")),
                          controller: _schemeController,
                          onSubmitted: (String? value) {
                            if (uri == null) {
                              return;
                            }
                            if (value != null) {
                              uri = uri!.replace(scheme: value);
                            }
                            _controller.text = uri.toString();
                            _parse();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration:
                              const InputDecoration(label: Text("Host")),
                          controller: _hostController,
                          onSubmitted: (String? value) {
                            if (uri == null) {
                              return;
                            }
                            if (value != null) {
                              uri = uri!.replace(host: value);
                            }
                            _controller.text = uri.toString();
                            _parse();
                            // _updateMainInputWithUri(uri!);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration:
                              const InputDecoration(label: Text("Path")),
                          controller: _pathController,
                          onSubmitted: (String? value) {
                            if (uri == null) {
                              return;
                            }
                            if (value != null) {
                              uri = uri!.replace(path: value);
                            }
                            _controller.text = uri.toString();
                            _parse();
                            // _updateMainInputWithUri(uri!);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration:
                              const InputDecoration(label: Text("Fragment")),
                          controller: _fragmentController,
                          onSubmitted: (String? value) {
                            if (uri == null) {
                              return;
                            }
                            if (value != null) {
                              uri = uri!.replace(fragment: value);
                            }
                            _controller.text = uri.toString();
                            _parse();
                            // _updateMainInputWithUri(uri!);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(label: Text("Query")),
                    controller: _queryController,
                    onSubmitted: (String? value) {
                      if (uri == null) {
                        return;
                      }
                      if (value != null) {
                        uri = uri!.replace(query: value);
                      }
                      _controller.text = uri.toString();
                      _parse();
                      // _updateMainInputWithUri(uri!);
                    },
                  ),
                ),
                if (uri != null && uri!.hasQuery)
                  QueryListView(
                    queryParameters: uri!.queryParameters,
                    onQueryUpdate: _onQueryUpdate,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _clear() {
    super.clear();
    setState(() {
      uri = null;
      _controller.clear();
      _pathController.clear();
      _hostController.clear();
      _queryController.clear();
      _schemeController.clear();
      _fragmentController.clear();
    });
  }

  void _paste() async {
    await paste();
    if (toolObject.input != null) {
      _controller.text = toolObject.input!;
    }
    _parse();
  }

  void _parse() {
    final _url = _controller.text;
    toolObject.input = _url;
    final parsedUri = toolObject.parseString(_url);
    setState(() {
      _hostController.text = parsedUri.host;
      _pathController.text = parsedUri.path;
      _queryController.text = parsedUri.query;
      _schemeController.text = parsedUri.scheme;
      _fragmentController.text = parsedUri.fragment;
      uri = parsedUri;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pathController.dispose();
    _hostController.dispose();
    _queryController.dispose();
    _schemeController.dispose();
    _fragmentController.dispose();
    super.dispose();
  }

  void _onQueryUpdate(Map<String, String> queryParameters) {
    final newUri = uri!.replace(queryParameters: queryParameters);
    _controller.text = newUri.toString();
    _parse();
  }

  void _encodeUrl() {
    final _url = _controller.text;

    final encoded = Uri.encodeFull(_url);
    _controller.text = encoded;
    _parse();
    // _updateMainInputWithUri(Uri.parse(encoded));
  }

  void _decodeUrl() {
    final _url = _controller.text;

    final decoded = Uri.decodeFull(_url);
    _controller.text = decoded;
    _parse();
  }

  @override
  void showError() {
    // TODO: implement showError
  }
}
