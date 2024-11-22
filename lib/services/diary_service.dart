import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/diary.dart';
import '../database/database_helper.dart';

class DiaryService {
  static Future<Diary> createDiary(
      {title, content, imageUrl, userId, imageLocalPath}) async {
    // Supabase에 저장
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('diaries')
        .insert({
          'title': title,
          'content': content,
          'imageUrl': imageUrl,
          'userId': userId,
        })
        .select()
        .single();

    // Supabase에서 반환된 ID로 Diary 객체 업데이트
    final updatedDiary = Diary(
      id: response['id'],
      title: response['title'],
      content: response['content'],
      imageUrl: response['imageUrl'],
      userId: response['userId'],
      createdAt: response['createdAt'],
      updatedAt: response['updatedAt'],
      imageLocalPath: imageLocalPath,
    );

    await DatabaseHelper.instance.insertDiary(updatedDiary);

    return updatedDiary;
  }
}
