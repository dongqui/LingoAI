import 'package:flutter/material.dart';
import '../services/image_generation_service.dart';
import '../providers/diary_provider.dart';
import 'package:provider/provider.dart';

class ImageGenerationScreen extends StatelessWidget {
  final String initialPrompt;

  const ImageGenerationScreen({
    Key? key,
    required this.initialPrompt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final diary = Provider.of<DiaryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Image'),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                if (diary.title.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      diary.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (diary.content.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      diary.content,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_imageUrl != null)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _imageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  )
                else
                  const Text('이미지 생성에 실패했습니다'),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: const Color(0xFF1A1A1A),
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FloatingActionButton.extended(
                  elevation: 0,
                  onPressed: () {
                    // Select Image 로직
                  },
                  label: const Text(
                    'Select Image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color(0xFF4D4EE8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
