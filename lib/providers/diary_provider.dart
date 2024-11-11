import 'package:flutter/foundation.dart';
import '../services/image_generation_service.dart';

class DiaryProvider with ChangeNotifier {
  String _title = '';
  String _content = '';
  String _imageUrl = '';
  bool _isLoading = false;
  final ImageGenerationService _imageService = ImageGenerationService();

  String get title => _title;
  String get content => _content;
  String get imageUrl => _imageUrl;
  bool get isLoading => _isLoading;

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setContent(String content) {
    _content = content;
    notifyListeners();
  }

  Future<void> generateImage() async {
    _isLoading = true;
    notifyListeners();

    try {
      _imageUrl = await _imageService.generateImage(_content);
    } catch (e) {
      // 에러 처리
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
