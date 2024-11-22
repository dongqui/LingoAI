import 'package:flutter/material.dart';
import '../providers/diary_provider.dart';
import 'package:provider/provider.dart';
import '../services/gallery_service.dart';
import 'package:go_router/go_router.dart';
import '../services/diary_service.dart';

class ImageGenerationScreen extends StatelessWidget {
  const ImageGenerationScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final diary = Provider.of<DiaryProvider>(context);

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
                  Container(
                    color: const Color(0xFF1A1A1A),
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FloatingActionButton.extended(
                        elevation: 0,
                        onPressed: () async {
                          try {
                            final imagePath =
                                await GalleryService.saveUrlToFile(
                                    diary.imageUrl, diary.title);

                            await DiaryService.createDiary(
                              title: diary.title,
                              content: diary.content,
                              imageUrl: diary.imageUrl,
                              userId: diary.userId,
                              imageLocalPath: imagePath,
                            );

                            if (context.mounted) {
                              context.go('/');
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
                        label: const Text(
                          'Confirm',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
