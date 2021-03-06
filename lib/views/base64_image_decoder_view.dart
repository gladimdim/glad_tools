import 'package:flutter/material.dart';
import 'package:glad_tools/components/ui/bordered_all.dart';
import 'package:glad_tools/tools/base64_image/base64_image_tool.dart';
import 'package:glad_tools/utils/clipboard_manager.dart';
import 'package:glad_tools/views/tool_widget.dart';

class Base64ImageDecoderView extends ToolWidget<Base64ImageTool> {
  const Base64ImageDecoderView({
    Key? key,
    required Base64ImageTool tool,
  }) : super(key: key, tool: tool);

  @override
  _Base64ImageDecoderViewState createState() => _Base64ImageDecoderViewState();
}

class _Base64ImageDecoderViewState extends ToolWidgetState<Base64ImageDecoderView, Base64ImageTool> {
  String? _base64;
  Image? _image;

  @override
  void initState() {
    super.initState();
    _base64 = toolObject.input;
    _decode();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TextButton(
              onPressed: _decode,
              child: const Text("Decode"),
            ),
            TextButton(
              onPressed: clear,
              child: const Text("Clear"),
            ),
            IconButton(onPressed: copy, icon: const Icon(Icons.copy)),
            IconButton(onPressed: _paste, icon: const Icon(Icons.paste)),
          ],
        ),
        if (_image != null)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                  "Decode result. Black border is not a part of your image."),
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

  @override
  void clear() {
    super.clear();
    setState(() {
      _base64 = null;
      _image = null;
    });
  }

  void _paste() async {
    await paste();

    if (toolObject.input != null) {
      _base64 = toolObject.input!;
      _decode();
    }
  }

  void _decode() {
    errorString = null;
    var sImage = _base64;
    if (sImage == null) {
      return;
    }

    try {
      _image = Base64ImageTool.stringToImage(sImage);
    } catch (e) {
      errorString = e.toString();
    }
    setState(() {});
  }

  @override
  void showError() {
    if (errorString == null) {
      return;
    }
  }
}
