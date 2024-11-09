import 'package:flutter/foundation.dart';

class DiaryProvider with ChangeNotifier {
  String _title = '';
  String _content = '';

  String get title => _title;
  String get content => _content;

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setContent(String content) {
    _content = content;
    notifyListeners();
  }

  void clear() {
    _title = '';
    _content = '';
    notifyListeners();
  }
} 