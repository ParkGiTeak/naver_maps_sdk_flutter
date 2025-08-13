import 'package:flutter/foundation.dart';

class NSDictionaryUtil {
  static String convert(String dictString) {
    if (dictString.isEmpty) {
      return '{}';
    }

    try {
      String result = _parseValue(dictString.trim());
      return result;
    } catch (e, stacktrace) {
      if (kDebugMode) {
        debugPrint('NSDictionary to JSON conversion failed: $e');
        debugPrint(stacktrace.toString());
      }
      return '{}';
    }
  }

  static String _parseValue(String value) {
    value = value.trim();

    // 중괄호로 둘러싸인 객체인 경우
    if (value.startsWith('{') && value.endsWith('}')) {
      return _parseObject(value);
    }

    // 따옴표로 둘러싸인 문자열인 경우
    if (value.startsWith('"') && value.endsWith('"')) {
      String cleanValue = value.substring(1, value.length - 1);
      // 숫자인지 확인
      if (RegExp(r'^\d+(\.\d+)?$').hasMatch(cleanValue)) {
        return cleanValue; // 숫자는 따옴표 없이
      } else {
        return value; // 문자열은 따옴표 유지
      }
    }

    // 숫자인지 확인
    if (RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
      return value;
    }

    // 기본적으로 문자열로 처리
    return '"$value"';
  }

  static String _parseObject(String objString) {
    if (objString.length <= 2) return '{}';

    String innerString = objString.substring(1, objString.length - 1).trim();
    if (innerString.isEmpty) return '{}';

    List<String> jsonPairs = [];
    int pos = 0;

    while (pos < innerString.length) {
      // 공백 건너뛰기
      while (pos < innerString.length && innerString[pos].trim().isEmpty) {
        pos++;
      }
      if (pos >= innerString.length) break;

      // 키 찾기
      int keyStart = pos;
      while (pos < innerString.length &&
          innerString[pos] != '=' &&
          innerString[pos].trim().isNotEmpty) {
        pos++;
      }

      if (pos >= innerString.length) break;

      String key = innerString.substring(keyStart, pos).trim();
      if (key.startsWith('"') && key.endsWith('"')) {
        // 이미 따옴표가 있는 경우 그대로 사용
      } else {
        key = '"$key"'; // 따옴표 추가
      }

      // '=' 건너뛰기
      while (pos < innerString.length && innerString[pos] != '=') {
        pos++;
      }
      if (pos < innerString.length) pos++; // '=' 건너뛰기

      // 공백 건너뛰기
      while (pos < innerString.length && innerString[pos].trim().isEmpty) {
        pos++;
      }

      if (pos >= innerString.length) break;

      // 값 찾기
      String value;
      if (innerString[pos] == '{') {
        // 중첩된 객체 찾기
        int braceCount = 0;
        int valueStart = pos;
        while (pos < innerString.length) {
          if (innerString[pos] == '{') {
            braceCount++;
          } else if (innerString[pos] == '}') {
            braceCount--;
            if (braceCount == 0) {
              pos++;
              break;
            }
          }
          pos++;
        }
        value = innerString.substring(valueStart, pos);
      } else {
        // 일반 값 찾기 (세미콜론까지)
        int valueStart = pos;
        while (pos < innerString.length && innerString[pos] != ';') {
          pos++;
        }
        value = innerString.substring(valueStart, pos).trim();
      }

      // 값 파싱
      String parsedValue = _parseValue(value);
      jsonPairs.add('$key: $parsedValue');

      // 세미콜론 건너뛰기
      while (pos < innerString.length && innerString[pos] != ';') {
        pos++;
      }
      if (pos < innerString.length) pos++; // ';' 건너뛰기
    }

    return '{${jsonPairs.join(', ')}}';
  }
}
