import '../models/diary.dart';
import '../database/database_helper.dart';

class DiaryService {
  static Future<void> createDiary(
      {title, content, imageUrl, userId, imageLocalPath, date}) async {
    final diary = Diary(
      id: 0,
      title: title,
      content: content,
      imageUrl: imageUrl,
      userId: userId,
      imageLocalPath: imageLocalPath,
      date: date,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    await DatabaseHelper.instance.insertDiary(diary);
  }
}
