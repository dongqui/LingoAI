import '../services/image_generation_service.dart';
import '../widgets/ad_loading_screen.dart';
import 'package:flutter/material.dart';

class DiaryInputProvider with ChangeNotifier {
  String _title = '';
  String _content = '';
  String _imageUrl = '';
  String _userId = '';
  String _date = '';
  bool _isGeneratingImage = false;
  String _prompt = '';
  final ImageGenerationService _imageService = ImageGenerationService();

  String get title => _title;
  String get content => _content;
  String get imageUrl => _imageUrl;
  String get userId => _userId;
  bool get isGeneratingImage => _isGeneratingImage;
  String get date => _date;
  String get prompt => _prompt;

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

  Future<void> generateImage(BuildContext context) async {
    _isGeneratingImage = true;
    notifyListeners();

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AdLoadingScreen(),
      );
    }

    try {
      _imageUrl = await _imageService.generateImage(
        content: _content,
        title: _title,
        userId: _userId,
        extraPromtp: _prompt,
      );
    } catch (e) {
      debugPrint('이미지 생성 오류: $e');
    } finally {
      _isGeneratingImage = false;
      notifyListeners();
    }
  }

  void updateImagePath(String path) {
    _imageUrl = path;
  }

  void setPrompt(String value) {
    _prompt = value;
  }

  void resetAll() {
    _title = '';
    _content = '';
    _imageUrl = '';
    _prompt = '';
    _userId = '';
    _date = '';
    notifyListeners();
  }
}
