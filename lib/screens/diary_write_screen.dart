import 'package:flutter/material.dart';

class DiaryWriteScreen extends StatefulWidget {
  const DiaryWriteScreen({super.key});

  @override
  State<DiaryWriteScreen> createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends State<DiaryWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _generatedImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 일기 작성'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDiary,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            if (_generatedImageUrl != null)
              Image.network(
                _generatedImageUrl!,
                height: 200,
              ),
            ElevatedButton(
              onPressed: _generateImage,
              child: const Text('AI 그림 생성하기'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateImage() async {
    // OpenAI 이미지 생성 로직 구현
  }

  void _saveDiary() {
    // 일기 저장 로직 구현
  }
}
