import 'package:flutter/material.dart';
import '../services/image_generation_service.dart';

enum GenerationState {
  loading,
  confirmation,
}

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
  late TextEditingController _promptController;
  GenerationState _state = GenerationState.loading;
  String? _generatedImage;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController(text: widget.initialPrompt);
    _generateImage();
  }

  Future<void> _generateImage() async {
    setState(() {
      _state = GenerationState.loading;
    });

    try {
      final imageUrls = await generateImage(_promptController.text);
      setState(() {
        _generatedImage = imageUrls[0];
        _state = GenerationState.confirmation;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지 생성에 실패했습니다')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_state == GenerationState.loading ? '이미지 생성 중' : '이미지 확인'),
        actions: [
          if (_state == GenerationState.confirmation)
            TextButton(
              onPressed: () {
                Navigator.pop(context, {
                  'prompt': _promptController.text,
                  'imageUrl': _generatedImage,
                });
              },
              child: const Text('확정'),
            ),
        ],
      ),
      body: _state == GenerationState.loading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('이미지를 생성하고 있습니다...'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Image.network(
                    _generatedImage!,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _promptController,
                    decoration: InputDecoration(
                      labelText: '프롬프트 수정',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _generateImage,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
