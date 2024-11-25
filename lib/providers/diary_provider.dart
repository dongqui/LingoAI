import 'package:flutter/foundation.dart';
import '../models/diary.dart';
import '../database/database_helper.dart';
import '../services/diary_service.dart';
import '../services/gallery_service.dart';

class DiaryProvider with ChangeNotifier {
  List<int> diaryDates = [];
  List<Diary> _diaries = [];
  List<Diary> get diaries => _diaries;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  bool _isAddingDiary = false;
  bool get isAddingDiary => _isAddingDiary;

  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDate => _focusedDate;
  DiaryProvider() {
    _init();
  }

  Future<void> _init() async {
    _diaries = await DatabaseHelper.instance.getDiariesForDate(_selectedDate);
    diaryDates = await getDiaryDates(_focusedDate);

    notifyListeners();
  }

  Future<void> setSelectedDate(DateTime date) async {
    _selectedDate = date;
    _focusedDate = date;

    _diaries = await DatabaseHelper.instance.getDiariesForDate(date);

    notifyListeners();
  }

  Future<List<Diary>> getDiariesForDate(DateTime date) async {
    return await DatabaseHelper.instance.getDiariesForDate(date);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> setFocusedDate(DateTime date) async {
    _focusedDate = date;
    // 해당 월의 첫날과 마지막 날 계산
    diaryDates = await getDiaryDates(date);

    notifyListeners();
  }

  Future<List<int>> getDiaryDates(DateTime date) async {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);

    // 해당 월의 일기들 가져오기
    final diaries =
        await DatabaseHelper.instance.getDiariesForMonth(firstDay, lastDay);

    return diaries
        .map((diary) => DateTime.parse(diary.date).day)
        .toSet()
        .toList();
  }

  Future<void> addDiary({
    required String title,
    required String content,
    required String imageUrl,
    required String userId,
    required String date,
  }) async {
    _isAddingDiary = true;
    notifyListeners();

    try {
      print('imageUrl: $imageUrl');
      final imageLocalPath =
          await GalleryService.saveUrlToFile(imageUrl, title);
      print('imageLocalPath: $imageLocalPath');
      await DiaryService.createDiary(
        title: title,
        content: content,
        imageUrl: imageUrl,
        userId: userId,
        imageLocalPath: imageLocalPath,
        date: date,
      );

      _diaries = await DatabaseHelper.instance.getDiariesForDate(_selectedDate);
      diaryDates = await getDiaryDates(_focusedDate);
    } finally {
      _isAddingDiary = false;
      notifyListeners();
    }
  }

  Future<void> deleteDiary(int id) async {
    final index = _diaries.indexWhere((diary) => diary.id == id);
    if (index != -1) {
      await DatabaseHelper.instance.deleteDiary(id);

      _diaries = await DatabaseHelper.instance.getDiariesForDate(_selectedDate);
      diaryDates = await getDiaryDates(_focusedDate);

      notifyListeners();
    }
  }
}
