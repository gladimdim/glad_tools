import 'package:glad_tools/tools/json_beautify/json_tools.dart';
import 'package:test/test.dart';

void main() {
  group("JSON Tool tests", () {
    test("Can minify json object with given indent #1", () {
      final obj = { "test": 3, "array": [1, 2, 3] };
      final result = JsonTools.formatMapToString(obj, 2);
      const expected = """{\n   \"test\": 3,\n   \"array\": [\n      1,\n      2,\n      3\n   ]\n}""";
      expect(result, equals(expected), reason: "Map was minified into string with indent 2");
    });

    test("Can minify json object with given indent #2", () {
      final obj = { "test": 3, "array": [1, 2, 3] };
      final result = JsonTools.formatMapToString(obj, 4);
      const expected = """{\n     \"test\": 3,\n     \"array\": [\n          1,\n          2,\n          3\n     ]\n}""";
      expect(result, equals(expected), reason: "Map was minified into string with indent 4");
    });

    test("Can parse string into JSON and then minify it", () async {
      const input = """{"object":   null,   "array":   [1, \n2, {  "anotherObject": true}]}""";
      final result = await JsonTools.minifyString(input);
      const expected = """{"object":null,"array":[1,2,{"anotherObject":true}]}""";
      expect(result, expected, reason: "String was minified");
    });
  });
}
