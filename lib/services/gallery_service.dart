import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class GalleryService {
  /// URL로부터 내부 저장소에 저장
  static Future<String> saveUrlToFile(String url, String filename) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw '이미지 다운로드 실패';
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/images/$filename');
      await file.create(recursive: true);
      await file.writeAsBytes(response.bodyBytes);

      return file.path; // 저장된 파일 경로 반환
    } catch (e) {
      debugPrint('URL 이미지 저장 중 오류 발생: $e');
      rethrow;
    }
  }
}
