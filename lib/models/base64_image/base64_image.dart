import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
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
  const Base64ImageContent({Key? key}) : super(key: key);

  @override
  _Base64ImageContentState createState() => _Base64ImageContentState();
}

class _Base64ImageContentState extends State<Base64ImageContent> {
  final TextEditingController _controller = TextEditingController();
  Image? _image;

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
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: BorderedAll(
                  child: TextField(
                    onChanged: (_) => _textChanged(),
                    decoration:
                        InputDecoration(hintText: "Paste base64 image string"),
                    minLines: 5,
                    maxLines: 15,
                    controller: _controller,
                  ),
                ),
              ),
              if (_image != null)
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Decode result:"),
                      ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 500,
                            minWidth: 500,
                          ),
                          child: _image),
                    ],
                  ),
                ),
              if (_image == null)
                Text(
                    "No image to show. Paste text to decode the base64 string into image"),
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
        TextPosition(offset: 0),
      ),
    );
    _image = null;
    setState(() {});
  }

  void _format() {
    var sImage = _controller.text;
    final containsMeta = sImage.contains("data:image");
    if (containsMeta) {
      sImage = sImage.split(",")[1];
    }
    Uint8List bytes = base64Decode(sImage);
    _image = Image.memory(
      bytes,
      fit: BoxFit.fitWidth,
    );
    setState(() {});
  }

  void _textChanged() {
    setState(() {
      _image = null;
    });
  }
}
