import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glad_tools/components/ui/bordered_all.dart';
import 'package:glad_tools/models/base_class.dart';

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
        TextField(
          decoration: const InputDecoration(
            hintText: "Paste URL to process",
          ),
          controller: _controller,
          onSubmitted: (_) => _parse(),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                ),
                child: TextField(
                  decoration: const InputDecoration(label: Text("Host")),
                  controller: _hostController,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                ),
                child: TextField(
                  decoration: const InputDecoration(label: Text("Path")),
                  controller: _pathController,
                  onSubmitted: (String? value) {
                    if (uri == null) {
                      return;
                    }
                    if (value != null) {
                      uri!.replace(path: value);
                    }
                    _updateMainInputWithUri(uri!);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _updateMainInputWithUri(Uri uri) {
    setState(() {
      _controller.text = uri.toString();
    });
  }

  _clear() {
    setState(() {
      url = null;
      errorString = null;
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
    _hostController.text = parsedUri.host;
    _pathController.text = parsedUri.path;
    uri = parsedUri;
  }

  void dispose() {
    _controller.dispose();
    _pathController.dispose();
    _hostController.dispose();
    super.dispose();
  }
}
