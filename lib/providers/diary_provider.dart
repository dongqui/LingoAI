import 'package:flutter/foundation.dart';
import '../models/diary.dart';
import '../database/database_helper.dart';

class DiaryProvider with ChangeNotifier {
  List<int> diaryDates = [];
  List<Diary> _diaries = [];
  List<Diary> get diaries => _diaries;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDate => _focusedDate;
  DiaryProvider() {
    _init();
  }

  Future<void> _init() async {
    _diaries = await DatabaseHelper.instance.getDiariesForDate(_selectedDate);
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
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);

    // 해당 월의 일기들 가져오기
    final diaries =
        await DatabaseHelper.instance.getDiariesForMonth(firstDay, lastDay);
    diaryDates =
        diaries.map((diary) => DateTime.parse(diary.date).day).toSet().toList();

    notifyListeners();
  }
}
