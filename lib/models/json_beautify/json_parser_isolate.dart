import 'dart:convert';
import 'dart:isolate';

class JsonParserIsolate {
  final String input;

  JsonParserIsolate(this.input);

  Future parseJson() async {
    var port = ReceivePort();
    await Isolate.spawn(_parse, port.sendPort);
    return await port.first;
  }

  Future<void> _parse(SendPort p) async {
    final json = jsonDecode(input);
    Isolate.exit(p, json);
  }
}