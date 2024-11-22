import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImageGenerationService {
  Future<String> generateImage({
    required String content,
    required String title,
    required String userId,
  }) async {
    // const apiUrl = dotenv.env['LOCAL_IMAGE_GENERATION_API_URL'];
    var apiUrl = dotenv.env['PRODUCTION_IMAGE_GENERATION_API_URL'];

    if (apiUrl == null) {
      throw Exception('API URL이 설정되지 않았습니다.');
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'content': content,
          'title': title,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['imageUrl'] as String;
      } else {
        throw Exception('API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('이미지 생성 실패: $e');
    }
  }
}
