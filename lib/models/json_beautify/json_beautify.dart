import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glad_tools/components/ui/bordered_all.dart';
import 'package:glad_tools/models/base_class.dart';

class JsonBeautify extends ToolObject {
  JsonBeautify()
      : super(
          title: "JSON Beautify",
          icon: const Icon(Icons.format_align_justify),
          contentBuilder: (context) => const JsonBeautifier(),
        );
}

class JsonBeautifier extends StatefulWidget {
  const JsonBeautifier({Key? key}) : super(key: key);

  @override
  _JsonBeautifierState createState() => _JsonBeautifierState();
}

class _JsonBeautifierState extends State<JsonBeautifier> {
  final TextEditingController _controller = TextEditingController();
  String? errorString;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: _format,
                child: const Text("Beautify"),
              ),
              TextButton(
                onPressed: _clear,
                child: const Text("Clear"),
              ),
              IconButton(onPressed: _copy, icon: const Icon(Icons.copy)),
              IconButton(onPressed: _paste, icon: const Icon(Icons.paste)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BorderedAll(
                    child: TextField(
                      onChanged: (_) => _textChanged(),
                      decoration: const InputDecoration(
                          hintText: "Paste JSON to process"),
                      minLines: 5,
                      maxLines: 15,
                      controller: _controller,
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
                      child: Text(
                          "An error has occurred while converting to image: $errorString"),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
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
    _format();
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: _controller.text));
  }

  void _format() {
    errorString = null;
    var map;
    try {
      map = jsonDecode(_controller.text);
    } catch (e) {
      reportError(e);
      return;
    }

    _controller.text = processString(map, 0, "");
  }

  String processString(input, int tabs, String str) {
    var shift = 4;
    if (input is List) {
      str += "[\n";
      for (var element in input) {
        str += processString(element, tabs + shift, "");
        if (input.last != element) {
          str += ",\n";
        }
      }
      str += "\n" + addSpaces(tabs) + "]";
    } else if (input is String) {
      str += input;
    } else if (input is num) {
      str += input.toString();
    } else if (input is Map) {
      str += "{\n";
      for (var entry in input.entries) {
        str += addSpaces(shift) + "\"${entry.key}\":";
        str += processString(entry.value, shift, "");
        if (input.entries.last.key != entry.key) {
          str += ",\n";
        } else {
          str += "\n";
        }
      }
      str += "}\n";
    }

    return addSpaces(tabs) + str;
  }

  String addSpaces(int amount) {
    amount = amount == 0 ? 4 : amount;
    var result = "";
    for (var i = 0; i < amount; i++) {
      result += " ";
    }
    return result;
  }

  void reportError(Object e) {
    setState(() {
      errorString = "Error while parsing JSON: ${e.toString()}";
    });
  }

  void _textChanged() {}
}
