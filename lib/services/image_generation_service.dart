import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageGenerationService {
  Future<String> generateImage(String prompt) async {
    const apiUrl = 'http://10.0.2.2:54321/functions/v1/generate-image';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'content': prompt,
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
