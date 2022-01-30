import 'package:glad_tools/tools/json_beautify/json_tools.dart';
import 'package:test/test.dart';

void main() {
  group("JSON Tool tests", () {
    test("Can minify json object", () {
      final obj = { "test": 3, "array": [1, 2, 3] };
      final result = JsonTools.formatMapToString(obj, 2);
      final expected = """{\n   \"test\": 3,\n   \"array\": [\n      1,\n      2,\n      3\n   ]\n}""";
      expect(result, equals(expected), reason: "Map was minified into string");
    });
  });
}
