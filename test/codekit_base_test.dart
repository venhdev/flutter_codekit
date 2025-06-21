import 'package:codekit/codekit.dart';
import 'package:test/test.dart';

void main() {
  group('codekit_base', () {
    group('indentJson', () {
      test('should format JSON with default indentation', () {
        final data = {'name': 'John', 'age': 30};
        final result = indentJson(data);
        expect(result, equals('{\n  "name": "John",\n  "age": 30\n}'));
      });

      test('should format JSON with custom indentation', () {
        final data = {'name': 'John', 'age': 30};
        final result = indentJson(data, indent: '    ');
        expect(result, equals('{\n    "name": "John",\n    "age": 30\n}'));
      });

      test('should truncate long fields when maxFieldLength is specified', () {
        final data = {
          'longText': 'This is a very long text that should be truncated'
        };
        final result = indentJson(data, maxFieldLength: 4);
        expect(result, '{\n  "longText": "This..."\n}');
      });

      test('should handle custom truncation tag', () {
        final data = {'longText': 'This is a very long text'};
        final result = indentJson(data,
            maxFieldLength: 19, truncateTag: '[...]', indent: '  ');
        expect(
            result, equals('{\n  "longText": "This is a very long[...]"\n}'));
      });

      test('should truncate nested fields when maxFieldLength is specified',
          () {
        final data = {
          'user': {
            'name': 'John Doe',
            'bio': 'This is a very long biography that should be truncated'
          }
        };
        final result = indentJson(data, maxFieldLength: 24);
        expect(result,
            '{\n  "user": {\n    "name": "John Doe",\n    "bio": "This is a very long biog..."\n  }\n}');
      });

      test('should handle nested JSON', () {
        final data = {
          'user': {
            'name': 'John',
            'address': {'street': '123 Main St', 'city': 'New York'}
          }
        };
        final result = indentJson(data);
        expect(
            result,
            equals(
                '{\n  "user": {\n    "name": "John",\n    "address": {\n      "street": "123 Main St",\n      "city": "New York"\n    }\n  }\n}'));
      });

      test('should handle empty data', () {
        final result = indentJson({});
        expect(result, equals('{}'));
      });

      test('should handle null values', () {
        final result = indentJson({'name': null});
        expect(result, equals('{\n  "name": null\n}'));
      });

      test('should handle boolean values', () {
        final result = indentJson({'active': true});
        expect(result, equals('{\n  "active": true\n}'));
      });
    });

    group('stringify', () {
      test('should handle null input', () {
        expect(stringify(null), equals(''));
      });

      test('should handle string input with maxLength', () {
        final longString = 'This is a very long string';
        expect(stringify(longString, maxLen: 10), equals('This is a '));
      });

      test('should handle function input', () {
        final result = stringify(() => 'Hello from function');
        expect(result, equals('Hello from function'));
      });

      test('should handle JSON serializable input with indent', () {
        final data = {'name': 'John', 'age': 30};
        final result = stringify(data, jsonIndent: '  ');
        expect(result, equals('{\n  "name": "John",\n  "age": 30\n}'));
      });

      test('should handle JSON serializable input with field length limit', () {
        final data = {"longText": "This is a very long text"};
        final result = stringify(data, jsonMaxFieldLen: 10, jsonIndent: '  ');
        expect(result, '{\n  "longText": "This is a ..."\n}');
      });

      test('should handle non-serializable input', () {
        final data = Object();
        final result = stringify(data);
        expect(result, equals(data.toString()));
        expect(stringify(data), isNot(throwsException));
      });
    });
  });
}
