import 'package:flutter/material.dart';
import '../providers/diary_input_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/diary_provider.dart';

class ImageGenerationScreen extends StatelessWidget {
  const ImageGenerationScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final diary = Provider.of<DiaryInputProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Image'),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          diary.imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey[850],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      diary.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      diary.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
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
                  backgroundColor: context.watch<DiaryProvider>().isAddingDiary
                      ? const Color(0xFF4D4EE8).withOpacity(0.5)
                      : const Color(0xFF4D4EE8),
                  onPressed: context.watch<DiaryProvider>().isAddingDiary
                      ? null
                      : () async {
                          try {
                            final diaryProvider = context.read<DiaryProvider>();
                            await diaryProvider.addDiary(
                              title: diary.title,
                              content: diary.content,
                              imageUrl: diary.imageUrl,
                              userId: diary.userId,
                              date: diary.date,
                            );

                            if (context.mounted) {
                              context.go('/home');
                            }
                          } catch (e) {
                            debugPrint(e.toString());
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('이미지 저장 중 오류가 발생했습니다!!!: $e')),
                              );
                            }
                          }
                        },
                  label: context.watch<DiaryProvider>().isAddingDiary
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
