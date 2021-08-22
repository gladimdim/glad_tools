import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glad_tools/components/ui/bordered_all.dart';
import 'package:glad_tools/models/base_class.dart';

class Base64Image extends ToolObject {
  Base64Image()
      : super(
            icon: const Icon(Icons.image),
            contentBuilder: (context) => const Base64ImageContent());
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
    return Column(
      children: [
        Text("Base64 Encode:"),
        BorderedAll(
          child: TextField(
            decoration: InputDecoration(hintText: "Paste base64 image string"),
            minLines: 5,
            maxLines: 15,
            controller: _controller,
          ),
        ),
        if (_image != null) _image!,
        Row(
          children: [
            TextButton(
              onPressed: _format,
              child: Text("Format"),
            ),
            TextButton(
              onPressed: _clear,
              child: Text("Clear"),
            ),
          ],
        ),
      ],
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
    Uint8List bytes = base64Decode(sImage);
    _image = Image.memory(bytes);
    setState(() {});
  }
}
