import 'dart:convert';

const String _truncateTag = '...';

/// Formats JSON data with indentation and optional field length truncation.
/// [data] The data to format as JSON
/// [indent] The indentation string (default: '  ')
/// [maxFieldLength] Maximum length for string fields (optional)
/// Returns: Formatted JSON string
String indentJson(
  dynamic data, {
  String? indent = '  ',
  int? maxFieldLength,
  String truncateTag = '...',
}) {
  try {
    final truncated = maxFieldLength != null
        ? _truncateJsonFields(data, maxFieldLength, truncateTag: truncateTag)
        : data;
    final encoder = JsonEncoder.withIndent(indent);
    return encoder.convert(truncated);
  } catch (e) {
    return stringify(data,
        jsonIndent: indent,
        jsonMaxFieldLen: maxFieldLength,
        maxLen: null,
        replacements: null);
  }
}

/// Recursively truncates string fields in JSON-like data structures.
/// [input] The input data to process
/// [maxLen] Maximum length for string fields
/// [truncateTag] Tag to append to truncated strings (default: '...')
/// Returns: Processed data with truncated string fields
dynamic _truncateJsonFields(dynamic input, int maxLen,
    {String truncateTag = _truncateTag}) {
  if (input is Map) {
    return input.map(
      (key, value) => MapEntry(
        key,
        value is String
            ? value.length > maxLen
                ? '${value.substring(0, maxLen)}$truncateTag'
                : value
            : value is Map
                ? _truncateJsonFields(value, maxLen, truncateTag: truncateTag)
                : value is List
                    ? value
                        .map((e) => e is String
                            ? e.length > maxLen
                                ? '${e.substring(0, maxLen)}$truncateTag'
                                : e
                            : e)
                        .toList()
                    : value,
      ),
    );
  } else if (input is List) {
    return input
        .map((e) => e is String
            ? e.length > maxLen
                ? '${e.substring(0, maxLen)}$truncateTag'
                : e
            : e)
        .toList();
  } else if (input is String) {
    return input.length > maxLen
        ? '${input.substring(0, maxLen)}$truncateTag'
        : input;
  } else {
    return input;
  }
}

/// Replaces substrings in a string using a map of replacements.
///
/// Replaces substrings in a string using a map of replacements.
/// [str] The input string
/// [replacements] Map of key-value pairs for replacements
/// Returns: Modified string with replacements applied
String _replaceInString(String str, Map<String, String> replacements) {
  var result = str;
  replacements.forEach((key, value) => result = result.replaceAll(key, value));
  return result;
}

/// Recursively replaces strings in a Map structure.
///
/// Recursively replaces strings in a Map structure.
/// [map] The input map
/// [replacements] Map of key-value pairs for replacements
/// Returns: Modified map with replacements applied
Map _replaceInMap(Map map, Map<String, String> replacements) {
  return map.map((key, value) => MapEntry(
        key is String ? _replaceInString(key, replacements) : key,
        value is String
            ? _replaceInString(value, replacements)
            : value is Map
                ? _replaceInMap(value, replacements)
                : value is List
                    ? _replaceInList(value, replacements)
                    : value,
      ));
}

/// Recursively replaces strings in a List structure.
///
/// Recursively replaces strings in a List structure.
/// [list] The input list
/// [replacements] Map of key-value pairs for replacements
/// Returns: Modified list with replacements applied
List _replaceInList(List list, Map<String, String> replacements) {
  return list
      .map((item) => item is String
          ? _replaceInString(item, replacements)
          : item is Map
              ? _replaceInMap(item, replacements)
              : item is List
                  ? _replaceInList(item, replacements)
                  : item)
      .toList();
}

String stringify(
  Object? input, {
  String? jsonIndent,
  int? jsonMaxFieldLen,
  int? maxLen,
  Map<String, String>? replacements,
  String truncateTag = _truncateTag,
}) {
  if (input == null) {
    return ''; // Handles null values, returns an empty string
  }
  if (input is String) {
    var result = input;
    if (replacements != null) {
      result = _replaceInString(result, replacements);
    }
    return maxLen != null && result.length > maxLen
        ? result.substring(0, maxLen)
        : result;
  }

  // If it's a function, call it to get the actual value
  // Otherwise, use the text itself
  dynamic finalText = input is Function ? input() : input;

  // Handle Maps and Iterables (Lists, Sets) by converting them to JSON strings
  if (finalText is Map || finalText is Iterable) {
    try {
      // Apply replacements to Map/List before converting to JSON
      if (replacements != null) {
        if (finalText is Map) {
          finalText = _replaceInMap(finalText, replacements);
        } else if (finalText is List) {
          finalText = _replaceInList(finalText, replacements);
        }
      }
      // Using indentJson for consistent JSON formatting
      String result = indentJson(finalText,
          indent: jsonIndent,
          maxFieldLength: jsonMaxFieldLen,
          truncateTag: truncateTag);
      return maxLen != null && result.length > maxLen
          ? result.substring(0, maxLen)
          : result;
    } catch (e) {
      // Fallback in case of JSON encoding errors (e.g., non-serializable objects within Map/Iterable)
      return finalText.toString();
    }
  } else {
    // For all other types (numbers, booleans, custom objects, etc.),
    // use their default toString() representation.
    String result = finalText.toString();
    // Apply replacements if provided
    if (replacements != null) {
      replacements
          .forEach((key, value) => result = result.replaceAll(key, value));
    }
    return maxLen != null && result.length > maxLen
        ? result.substring(0, maxLen)
        : result;
  }
}
