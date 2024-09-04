import 'dart:convert'; // For encoding the JSON data
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

Future<String?> sendPostRequest(String sentence, String language) async {
  final url = kReleaseMode
      ? Uri.parse(dotenv.env['PROD_API_BASE_URL']!)
      : Uri.parse(dotenv.env['DEV_API_BASE_URL']!);

  // 보낼 데이터
  final data = {
    'sentence': sentence,
    'language': language,
  };

  // POST 요청 보내기
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data), // 데이터를 JSON 형식으로 변환
    );
    final responseData = jsonDecode(response.body);
    return responseData.toString(); // 응답 데이터를 반환
  } catch (error) {
    print('Error occurred: $error');
    return null;
  }
}
