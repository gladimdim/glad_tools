import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glad_tools/components/ui/bordered_all.dart';
import 'package:glad_tools/models/tool_object.dart';

class Base64Image extends ToolObject {

  static dynamic rootObject;
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
  String? _base64;
  Image? _image;
  String? errorString;

  @override
  void initState() {
    super.initState();
    if (Base64Image.rootObject != null) {
      _base64 = Base64Image.rootObject as String;
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
        if (_image != null)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Decode result. Black border is not a part of your image."),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 115,
                child: BorderedAll(
                  child: InteractiveViewer(
                    child: _image!,
                    minScale: 0.1,
                    constrained: false,
                    maxScale: 3.0,
                  ),
                ),
              ),
            ],
          ),
        if (_image == null && errorString == null)
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                children: [
                  const Text(
                      "No image to show. Paste text to decode the base64 string into image"),
                  IconButton(
                    onPressed: _paste,
                    icon: const Icon(
                      Icons.paste,
                    ),
                    iconSize: 256,
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
                    "An error has occurred while converting to image: $errorString"),
              ),
            ),
          ),
      ],
    );
  }

  void _clear() {
    setState(() {
      Base64Image.rootObject = null;

      _base64 = null;
      _image = null;
      errorString = null;
    });
  }

  void _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      _base64 = data.text!;

      Base64Image.rootObject = _base64;
    }
    _format();
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: _base64));
  }

  void _format() {
    errorString = null;
    var sImage = _base64;
    if (sImage == null) {
      return;
    }
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
}
