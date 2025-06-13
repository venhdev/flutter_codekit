import 'dart:convert';

String indentJson(dynamic data, {String? indent}) {
  try {
    final encoder = JsonEncoder.withIndent(indent ?? '  ');
    final jsonStr = encoder.convert(data);
    return jsonStr;
  } catch (e) {
    return stringify(data);
  }
}

String stringify(dynamic input) {
  if (input == null) {
    return ''; // Handles null values, returns an empty string
  }
  if (input is String) {
    return input; // If it's already a string, return it directly
  }

  // If it's a function, call it to get the actual value
  // Otherwise, use the text itself
  final dynamic finalText = input is Function ? input() : input;

  // Handle Maps and Iterables (Lists, Sets) by converting them to JSON strings
  if (finalText is Map || finalText is Iterable) {
    try {
      // Using JsonEncoder with no indent for a compact string
      var encoder = const JsonEncoder.withIndent(null);
      return encoder.convert(finalText);
    } catch (e) {
      // Fallback in case of JSON encoding errors (e.g., non-serializable objects within Map/Iterable)
      return finalText.toString();
    }
  } else {
    // For all other types (numbers, booleans, custom objects, etc.),
    // use their default toString() representation.
    return finalText.toString();
  }
}
