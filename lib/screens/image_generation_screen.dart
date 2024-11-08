import 'package:flutter/material.dart';
import '../services/image_generation_service.dart';

class ImageGenerationScreen extends StatefulWidget {
  final String initialPrompt;

  const ImageGenerationScreen({
    super.key,
    required this.initialPrompt,
  });

  @override
  State<ImageGenerationScreen> createState() => _ImageGenerationScreenState();
}

class _ImageGenerationScreenState extends State<ImageGenerationScreen> {
  String? _imageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateImage();
  }

  Future<void> _generateImage() async {
    try {
      final imageUrl = await generateImage(widget.initialPrompt);
      setState(() {
        _imageUrl = imageUrl;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // 에러 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Image'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_imageUrl != null)
              Column(
                children: [
                  Image.network(
                    _imageUrl!,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const CircularProgressIndicator();
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'How do you like the image? Any adjustments needed? Feel free to provide your feedback for generating a new image.',
                      style: TextStyle(
                        color: Colors.white, // 흰색 텍스트
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.left,
                      softWrap: true,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter your feedback here...',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white, // TextField 배경만 흰색
                      ),
                    ),
                  ),
                ],
              )
            else
              const Text('이미지 생성에 실패했습니다'),
          ],
        ),
      ),
    );
  }
}
