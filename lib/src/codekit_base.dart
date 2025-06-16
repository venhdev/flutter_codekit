import 'dart:convert';

String indentJson(
  dynamic data, {
  String? indent = '  ',
  int? maxFieldLength = 500,
}) {
  try {
    final truncated = maxFieldLength != null
        ? _truncateJsonFields(data, maxFieldLength)
        : data;
    final encoder = JsonEncoder.withIndent(indent);
    return encoder.convert(truncated);
  } catch (e) {
    return stringify(data);
  }
}

dynamic _truncateJsonFields(
  dynamic input,
  int maxLen, {
  String truncateTag = '...',
}) {
  if (input is Map) {
    return input.map(
      (key, value) => MapEntry(key, _truncateJsonFields(value, maxLen)),
    );
  } else if (input is List) {
    return input.map((e) => _truncateJsonFields(e, maxLen)).toList();
  } else if (input is String) {
    return input.length > maxLen
        ? '${input.substring(0, maxLen)}$truncateTag'
        : input;
  } else {
    return input;
  }
}

String stringify(Object? input, {String? indent}) {
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
      var encoder = JsonEncoder.withIndent(indent);
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
