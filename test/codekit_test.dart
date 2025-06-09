import 'package:codekit/codekit.dart';
import 'package:test/test.dart';

void main() {
  test('test name', () {
    // Example of indentJson
    final Map<String, dynamic> data = {
      'name': 'Codekit',
      'version': '1.0.0',
      'features': ['indentJson', 'stringify'],
      'nested': {'key': 'value'},
    };
    print('Indented JSON:');
    print(indentJson(data));

    // Example of stringify
    print('\nStringify a function:');
    print(stringify(() => 'This is from a function'));

    print('\nStringify a list:');
    print(stringify([1, 2, 3]));

    print('\nStringify a string:');
    print(stringify('Hello Codekit!'));

    print('\nStringify null:');
    print(stringify(null));
  });
}
