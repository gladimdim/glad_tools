import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glad_tools/components/ui/bordered_all.dart';
import 'package:glad_tools/models/base_class.dart';
import 'package:glad_tools/views/main_view.dart';

class JwtParser extends ToolObject {
  JwtParser()
      : super(
          title: "JWT Parser",
          icon: const Icon(Icons.stars_outlined),
          contentBuilder: (context) => const JwtParserContent(),
        );
}

class JwtParserContent extends StatefulWidget {
  const JwtParserContent({
    Key? key,
  }) : super(key: key);

  @override
  _Base64ImageContentState createState() => _Base64ImageContentState();
}

class _Base64ImageContentState extends State<JwtParserContent> {
  final TextEditingController _controller = TextEditingController();
  Map? _parsed;
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

        if (_parsed != null)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - TOP_BAR_HEIGHT,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: 2,
                      decoration: const InputDecoration(
                        label: Text("JWT Token"),
                      ),
                      controller: _controller,
                    ),
                  ),
                  Text(
                    "Decoded payload",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        for (var entry in _parsed!.entries)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BorderedAll(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SelectableText(
                                      entry.key,
                                      style: Theme.of(context).textTheme.headline6,
                                    ),
                                    Text(
                                      ": ",
                                      style: Theme.of(context).textTheme.headline6,
                                    ),
                                    SelectableText(
                                      entry.value.toString(),
                                      style: Theme.of(context).textTheme.headline6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (errorString != null)
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                    "An error has occurred while decoding JWT Token: $errorString"),
              ),
            ),
          ),
      ],
    );
  }

  void _clear() {
    setState(() {
      _parsed = null;
      errorString = null;
      _controller.text = "";
    });
  }

  void _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data == null) {
      return;
    }
    _controller.text = data.text!;
    _parse();
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: _controller.text));
  }

  void _parse() {
    errorString = null;
    if (_controller.text == "") {
      return;
    }
    final parts = _controller.text.split(".");
    if (parts.length != 3) {
      updateWithError("JWT token is invalid");
      return;
    }
    String payloadString = parts[1];
    switch (payloadString.length % 4) {
      case 0:
        break;
      case 2:
        payloadString += "==";
        break;
      case 3:
        payloadString += '=';
        break;
      default:
        updateWithError("Invalid format");
    }
    final decodedString = utf8.decode(base64Decode(payloadString));
    setState(() {
      _parsed = jsonDecode(decodedString);
    });
  }

  void updateWithError(String error) {
    setState(() {
      _parsed = null;
      errorString = error;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
