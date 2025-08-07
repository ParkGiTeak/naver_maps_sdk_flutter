import 'package:flutter/foundation.dart';

class NSDictionaryUtil {
  static String convert(String dictString) {
    if (dictString.isEmpty ||
        !dictString.startsWith('{') ||
        !dictString.endsWith('}')) {
      return '{}';
    }

    try {
      String innerString = dictString
          .substring(1, dictString.length - 1)
          .trim();

      // 세미콜론 기준으로 키-값 쌍을 분리
      List<String> pairs = innerString.split(RegExp(r'\s*;\s*'));
      List<String> jsonPairs = [];

      for (String pair in pairs) {
        if (pair.isEmpty) continue;

        List<String> parts = pair.split(RegExp(r'\s*=\s*'));
        if (parts.length != 2) continue;

        String key = parts[0].trim();
        String value = parts[1].trim();

        // 키를 큰따옴표로 감쌈
        if (!key.startsWith('"')) {
          key = '"$key"';
        }

        // 값이 숫자 형태인지 확인하고 따옴표 제거
        String cleanValue = value.replaceAll('"', '');
        if (RegExp(r'^\d+(\.\d+)?$').hasMatch(cleanValue)) {
          jsonPairs.add('$key: $cleanValue');
        } else {
          // 숫자가 아닌 경우 따옴표 유지
          jsonPairs.add('$key: $value');
        }
      }

      return '{${jsonPairs.join(', ')}}';
    } catch (e, stacktrace) {
      if (kDebugMode) {
        debugPrint('NSDictionary to JSON conversion failed: $e');
        debugPrint(stacktrace.toString());
      }
      return '{}';
    }
  }
}
