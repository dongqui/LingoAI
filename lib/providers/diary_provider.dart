import 'package:flutter/foundation.dart';
import '../models/diary.dart';
import '../database/database_helper.dart';

class DiaryProvider with ChangeNotifier {
  List<Diary> _diaries = [];
  List<Diary> get diaries => _diaries;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDate => _focusedDate;

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
}
