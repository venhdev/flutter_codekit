A collection of essential utilities and extensions for Flutter and Dart development, designed to streamline common tasks and enhance productivity.

## Features

- **`indentJson` function**: Formats JSON data with a specified indent.
- **`stringify` function**: Converts various data types to their string representations, handling JSON serialization for Maps and Iterables.

## Getting started

To use `codekit`, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  codekit: ^0.0.1 # Or the latest version
```

Then, run `flutter pub get` or `dart pub get`.

## Usage

### `indentJson` and `stringify` functions

```dart
import 'package:codekit/codekit.dart';

void main() {
  // Example of indentJson
  final Map<String, dynamic> data = {
    'name': 'Codekit',
    'version': '1.0.0',
    'features': ['indentJson', 'stringify'],
    'nested': {
      'key': 'value'
    }
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
}
```

For more examples, see the `example` folder and `lib/src/codekit_example_new.dart`.

## Additional information

Feel free to contribute to this package by submitting issues or pull requests on GitHub. Your feedback and contributions are highly appreciated!
