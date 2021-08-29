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
  String? url;
  String? errorString;

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
      ],
    );
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
    final uri = Uri.parse(_url);
    print(uri.path);
    print(uri.fragment);
    print(uri.host);
    print(uri.data);
    print(uri.origin);
    print(uri.scheme);
    print(uri.queryParametersAll);
  }
}
