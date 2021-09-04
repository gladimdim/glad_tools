
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glad_tools/models/base_class.dart';
import 'package:glad_tools/models/url_parser/query_list.dart';

class UrlParser extends ToolObject {
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
  String? errorString;
  Uri? uri;

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
            TextButton(onPressed: _decodeUrl, child: Text("Decode")),
            TextButton(onPressed: _encodeUrl, child: Text("Encode")),

          ],
        ),
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
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 250),
              child: QueryListView(
                queryParameters: uri!.queryParameters,
                onQueryUpdate: _onQueryUpdate,
              ),
            ),
          ),
      ],
    );
  }

  _updateMainInputWithUri(Uri uri) {
    setState(() {
      _controller.text = uri.toString();
      _parse();
    });
  }

  _clear() {
    setState(() {
      errorString = null;
      uri = null;
      _controller.clear();
      _pathController.clear();
      _hostController.clear();
      _queryController.clear();
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
    }
    _parse();
  }

  void _parse() {
    final _url = _controller.text;
    final parsedUri = Uri.parse(_url);
    setState(() {
      _hostController.text = parsedUri.host;
      _pathController.text = parsedUri.path;
      _queryController.text = parsedUri.query;
      uri = parsedUri;

    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pathController.dispose();
    _hostController.dispose();
    _queryController.dispose();
    super.dispose();
  }

  void _onQueryUpdate(Map<String, String> queryParameters) {
    final newUri = uri!.replace(queryParameters: queryParameters);
    _controller.text = newUri.toString();
    _parse();
    // _updateMainInputWithUri(uri!.replace(queryParameters: queryParameters));
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
    // update main input will replace controller's text with a percent-encoded value
    // as we use Uri.toString method there. Here we force text field to have a readable URL
    // setState(() {
    //   uri = Uri.parse(decoded);
    //   _controller.text = decoded;
    // });

  }
}
