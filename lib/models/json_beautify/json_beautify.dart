import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glad_tools/components/ui/bordered_all.dart';
import 'package:glad_tools/models/base_class.dart';

class JsonBeautify extends ToolObject {
  static dynamic rootObject;

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
  int _whitespaceAmount = 2;

  @override
  void initState() {
    super.initState();
    if (JsonBeautify.rootObject != null) {
      _controller.text = JsonBeautify.rootObject as String;
      _format();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TextButton(
              onPressed: _format,
              child: const Text("Beautify"),
            ),
            const Text("Spaces: "),
            DropdownButton(
              onChanged: _whitespaceAmountChanged,
              value: _whitespaceAmount,
              items: [2, 4, 8].map((e) {
                return DropdownMenuItem<int>(
                    value: e, child: Text(e.toString()));
              }).toList(),
            ),
            TextButton(
              onPressed: _minify,
              child: const Text("Minify"),
            ),
            TextButton(
              onPressed: _clear,
              child: const Text("Clear"),
            ),
            IconButton(onPressed: _copy, icon: const Icon(Icons.copy)),
            IconButton(onPressed: _paste, icon: const Icon(Icons.paste)),
          ],
        ),
        SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BorderedAll(
                    color: errorString == null ? Colors.black : Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Paste JSON to process",
                        ),
                        minLines: 5,
                        maxLines: (MediaQuery.of(context).size.height ~/ 30),
                        controller: _controller,
                      ),
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
        ),
      ],
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
    JsonBeautify.rootObject = null;
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
    JsonBeautify.rootObject = _controller.text;
    setState(() {
      errorString = null;
      if (_controller.text.isEmpty) {
        return;
      }
      dynamic map;
      try {
        map = jsonDecode(_controller.text);
      } catch (e) {
        reportError(e);
        return;
      }

      _controller.text = formatString(map, 0);
    });
  }

  void _minify() {
    dynamic input;
    try {
      input = jsonDecode(_controller.text);
    } catch (e) {
      reportError(e);
      return;
    }

    _controller.text = _minifyString(input);
  }

  String _minifyString(input) {
    var inner = "";
    if (input is num) {
      inner = input.toString();
    } else if (input is String) {
      inner = "\"${input.toString()}\"";
    } else if (input is bool) {
      inner = input.toString();
    } else if (input is List) {
      inner = "[";
      for (var element in input) {
        inner += _minifyString(element);
        if (input.last != element) {
          inner += ",";
        }
      }
      inner += "]";
    } else if (input is Map) {
      inner = "{";
      for (var entry in input.entries) {
        inner += "\"${entry.key}\":";

        inner += _minifyString(entry.value);
        if (input.entries.last.key != entry.key) {
          inner += ",";
        }
      }
      inner += "}";
    }

    return inner;
  }

  String formatString(input, int base) {
    var inner = "";
    if (input is List) {
      inner += "[\n";
      for (var element in input) {
        inner +=
            addSpaces(base) + formatString(element, base + _whitespaceAmount);
        if (input.last != element) {
          inner += ",\n";
        } else {
          inner += "\n";
        }
      }
      inner += addSpaces(base + _whitespaceAmount) + "]";
    } else if (input is bool) {
      inner = addSpaces(base) + input.toString();
    } else if (input is String) {
      inner = addSpaces(base) + "\"$input\"";
    } else if (input is num) {
      inner += addSpaces(base) + input.toString();
    } else if (input is Map) {
      inner =
          (base == 0 ? "" : "\n") + addSpaces(base + _whitespaceAmount) + "{\n";
      for (var entry in input.entries) {
        inner += addSpaces(base + _whitespaceAmount) + "\"${entry.key}\": ";
        var nextBase = base;
        if (entry.value is bool ||
            entry.value is String ||
            entry.value is num) {
          nextBase = 1;
        } else {
          nextBase = base + _whitespaceAmount;
        }
        inner += formatString(entry.value, nextBase);
        if (input.entries.last.key != entry.key) {
          inner += ",\n";
        } else {
          inner += "\n";
        }
      }
      inner += addSpaces(base + _whitespaceAmount) + "}";
    }

    return inner;
  }

  String addSpaces(int amount) {
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

  void _whitespaceAmountChanged(int? value) {
    setState(() {
      int newValue = value ?? 2;

      _whitespaceAmount = newValue;
      _format();
    });
  }
}
