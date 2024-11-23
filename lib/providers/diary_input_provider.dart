import 'package:flutter/foundation.dart';
import '../services/image_generation_service.dart';

class DiaryInputProvider with ChangeNotifier {
  String _title = '';
  String _content = '';
  String _imageUrl = '';
  String _userId = '';
  String _date = '';
  bool _isLoading = false;
  final ImageGenerationService _imageService = ImageGenerationService();

  String get title => _title;
  String get content => _content;
  String get imageUrl => _imageUrl;
  String get userId => _userId;
  bool get isLoading => _isLoading;
  String get date => _date;

  void setDate(String date) {
    _date = date;
  }

  void setTitle(String title) {
    _title = title;
  }

  void setContent(String content) {
    _content = content;
  }

  void setUserId(String userId) {
    _userId = userId;
  }

  Future<void> generateImage() async {
    _isLoading = true;
    notifyListeners();

    try {
      _imageUrl = await _imageService.generateImage(
        content: _content,
        title: _title,
        userId: _userId,
      );
    } catch (e) {
      debugPrint('이미지 생성 오류: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateImagePath(String path) {
    _imageUrl = path;
  }
}
