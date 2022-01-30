import 'package:flutter/services.dart';
class ClipboardManager {
  static Future<String?> paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  static void copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}