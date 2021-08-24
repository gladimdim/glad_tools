import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glad_tools/components/ui/bordered_all.dart';
import 'package:glad_tools/models/base_class.dart';

class Base64Image extends ToolObject {
  Base64Image()
      : super(
          title: "Base64 Image Decoder",
          icon: const Icon(Icons.image),
          contentBuilder: (context) => const Base64ImageContent(),
        );
}

class Base64ImageContent extends StatefulWidget {
  const Base64ImageContent({
    Key? key,
  }) : super(key: key);

  @override
  _Base64ImageContentState createState() => _Base64ImageContentState();
}

class _Base64ImageContentState extends State<Base64ImageContent> {
  final TextEditingController _controller = TextEditingController();
  Image? _image;
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
                child: const Text("Decode"),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BorderedAll(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (_) => _textChanged(),
                        decoration: const InputDecoration(
                            hintText: "Paste base64 image string"),
                        minLines: 15,
                        maxLines: 20,
                        controller: _controller,
                      ),
                    ),
                  ),
                ),
              ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Decode result:"),
                      ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 500,
                            minWidth: 500,
                          ),
                          child: _image),
                    ],
                  ),
                ),
              if (_image == null && errorString == null)
                const Expanded(
                  flex: 1,
                  child: Center(
                    child: Center(
                      child: Text(
                          "No image to show. Paste text to decode the base64 string into image"),
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
    _image = null;
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
    var sImage = _controller.text;
    final containsMeta = sImage.contains("data:image");
    if (containsMeta) {
      sImage = sImage.split(",")[1];
    }
    try {
      Uint8List bytes = base64Decode(sImage);
      _image = Image.memory(
        bytes,
      );
    } catch (e) {
      errorString = e.toString();
    }
    setState(() {});
  }

  void _textChanged() {
    setState(() {
      _image = null;
    });
  }
}
