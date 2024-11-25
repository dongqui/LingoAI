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
    final diaryInputProvider = Provider.of<DiaryInputProvider>(context);
    final diaryProvider = Provider.of<DiaryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        centerTitle: true,
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
                        child: FutureBuilder<void>(
                          future: precacheImage(
                              NetworkImage(diaryInputProvider.imageUrl),
                              context),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Image.network(
                                diaryInputProvider.imageUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              );
                            }
                            return Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey[850],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF4D4EE8),
                                ),
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
                      diaryInputProvider.title,
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
                      diaryInputProvider.content,
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
        ],
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Opacity(
                opacity: diaryProvider.isAddingDiary ? 0.5 : 1.0,
                child: FloatingActionButton.extended(
                  heroTag: 'regenerate',
                  onPressed: diaryProvider.isAddingDiary
                      ? null
                      : () {
                          try {
                            context.push('/regenerate',
                                extra: diaryInputProvider.imageUrl);
                          } catch (e) {
                            print('Error: $e');
                          }
                        },
                  label: const Text(
                    'Try Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Opacity(
                opacity: diaryProvider.isAddingDiary ? 0.5 : 1.0,
                child: FloatingActionButton.extended(
                  onPressed: diaryProvider.isAddingDiary
                      ? null
                      : () async {
                          await diaryProvider.addDiary(
                            title: diaryInputProvider.title,
                            content: diaryInputProvider.content,
                            imageUrl: diaryInputProvider.imageUrl,
                            userId: diaryInputProvider.userId,
                            date: diaryInputProvider.date,
                          );
                          diaryInputProvider.resetAll();
                          if (context.mounted) {
                            context.replace('/home');
                          }
                        },
                  label: diaryProvider.isAddingDiary
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  backgroundColor: const Color(0xFF4D4EE8),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
