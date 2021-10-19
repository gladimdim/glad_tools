
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glad_tools/models/tool_object.dart';
import 'package:glad_tools/models/url_parser/query_list.dart';
import 'package:glad_tools/views/main_view.dart';

class UrlParser extends ToolObject {
  static dynamic rootObject;
  UrlParser()
      : super(
          title: "URL Tools",
          icon: const Icon(Icons.link),
          contentBuilder: (context) => const UrlParserContent(),
        );
}

class UrlParserContent extends StatefulWidget {
  const UrlParserContent({
    Key? key,
  }) : super(key: key);

  @override
  _Base64ImageContentState createState() => _Base64ImageContentState();
}

class _Base64ImageContentState extends State<UrlParserContent> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _pathController = TextEditingController();
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _schemeController = TextEditingController();
  String? errorString;
  Uri? uri;

  @override
  void initState() {
    super.initState();
    if (UrlParser.rootObject != null) {
      _controller.text = UrlParser.rootObject as String;
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
              child: const Text("Parse"),
            ),
            TextButton(
              onPressed: _clear,
              child: const Text("Clear"),
            ),
            IconButton(onPressed: _copy, icon: const Icon(Icons.copy)),
            IconButton(onPressed: _paste, icon: const Icon(Icons.paste)),
            TextButton(onPressed: _decodeUrl, child: const Text("Decode")),
            TextButton(onPressed: _encodeUrl, child: const Text("Encode")),

          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - TOP_BAR_HEIGHT,
          ),
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
                          decoration: const InputDecoration(label: Text("Scheme")),
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
                          decoration: const InputDecoration(label: Text("Host")),
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
                          decoration: const InputDecoration(label: Text("Path")),
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
                    ),
                  ],
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
    setState(() {
      errorString = null;
      uri = null;
      UrlParser.rootObject = null;
      _controller.clear();
      _pathController.clear();
      _hostController.clear();
      _queryController.clear();
      _schemeController.clear();
    });
  }

  _copy() {
    if (_controller.text != "") {
      Clipboard.setData(ClipboardData(text: _controller.text));
    }
  }

  void _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      _controller.text = data.text!;
    }
    _parse();
  }

  void _parse() {
    final _url = _controller.text;
    UrlParser.rootObject = _url;
    final parsedUri = Uri.parse(_url);
    setState(() {
      _hostController.text = parsedUri.host;
      _pathController.text = parsedUri.path;
      _queryController.text = parsedUri.query;
      _schemeController.text = parsedUri.scheme;
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
}
