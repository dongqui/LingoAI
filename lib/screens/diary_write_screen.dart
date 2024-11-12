import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diary_provider.dart';
import '../screens/image_generation_screen.dart';

class DiaryWriteScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _storyController = TextEditingController();

  DiaryWriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final diaryProvider = Provider.of<DiaryProvider>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Write Diary'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    'Title',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _titleController,
                  onChanged: (value) => diaryProvider.setTitle(value),
                  cursorColor: const Color(0xFF4D4EE8),
                  decoration: const InputDecoration(
                    hintText: '제목을 입력하세요',
                    hintStyle: TextStyle(color: Colors.white24),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    'Story',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _storyController,
                  onChanged: (value) => diaryProvider.setContent(value),
                  cursorColor: const Color(0xFF4D4EE8),
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: '오늘의 이야기를 들려주세요',
                    hintStyle: TextStyle(color: Colors.white24),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: FloatingActionButton.extended(
              elevation: 0,
              onPressed: () async {
                FocusScope.of(context).unfocus();
                final diaryProvider =
                    Provider.of<DiaryProvider>(context, listen: false);
                await diaryProvider.generateImage();

                if (!context.mounted) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ImageGenerationScreen(),
                  ),
                );
              },
              label: const Text(
                'Generate a image',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xFF4D4EE8),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
        if (diaryProvider.isLoading)
          Container(
            color: const Color(0xFF1A1A1A),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4D4EE8),
              ),
            ),
          ),
      ],
    );
  }
}
