import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

class JsonParserIsolate {
  final String input;

  JsonParserIsolate(this.input);

  Future parseJson({Function(String)? onError}) async {
    final completer = Completer();
    var port = ReceivePort();
    var errorPort = ReceivePort();
    await Isolate.spawn(_parse, port.sendPort, onError: errorPort.sendPort);

    errorPort.listen((message) {
      if (onError != null) {
        // first is Error Message
        // second is stacktrace which is not needed
        List errors = message as List;
        errorPort.close();
        onError(errors.first);
      }
    });

    port.listen((message) {
      port.close();
      completer.complete(message);
    });

    return completer.future;
  }

  Future<void> _parse(SendPort p) async {
    final json = jsonDecode(input);
    Isolate.exit(p, json);
  }
}
