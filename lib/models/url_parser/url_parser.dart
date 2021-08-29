import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glad_tools/components/ui/bordered_all.dart';
import 'package:glad_tools/models/base_class.dart';
import 'package:glad_tools/models/url_parser/query_list.dart';

class UrlParser extends ToolObject {
  UrlParser()
      : super(
          title: "URL Parser",
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
  String? url;
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
                    _updateMainInputWithUri(uri!);
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
                    _updateMainInputWithUri(uri!);
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
                    _updateMainInputWithUri(uri!);
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
      url = uri.toString();
      _parse();
    });
  }

  _clear() {
    setState(() {
      url = null;
      errorString = null;
      uri = null;
      _controller.clear();
      _pathController.clear();
      _hostController.clear();
      _queryController.clear();
    });
  }

  _copy() {
    if (url != null) {
      Clipboard.setData(ClipboardData(text: url));
    }
  }

  void _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      url = data.text!;
    }
    _parse();
  }

  void _parse() {
    final _url = _controller.text;
    if (_url == "") {
      return;
    }
    final parsedUri = Uri.parse(_url);
    setState(() {
      _hostController.text = parsedUri.host;
      _pathController.text = parsedUri.path;
      _queryController.text = parsedUri.query;
      _updateMainInputWithUri(parsedUri);
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
    _updateMainInputWithUri(uri!.replace(queryParameters: queryParameters));
  }
}
