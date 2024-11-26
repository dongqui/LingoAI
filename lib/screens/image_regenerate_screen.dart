import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diary_input_provider.dart';
import 'package:go_router/go_router.dart';

class ImageRegenerateScreen extends StatelessWidget {
  final String currentImageUrl;
  final ScrollController _scrollController = ScrollController();

  ImageRegenerateScreen({
    super.key,
    required this.currentImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final diaryProvider = context.watch<DiaryInputProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Image'),
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Image',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FutureBuilder<void>(
                  future: precacheImage(NetworkImage(currentImageUrl), context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Image.network(
                        currentImageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      );
                    }
                    return Container(
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
            const SizedBox(height: 24),
            const Text(
              'Prompt',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe the image you want',
                hintStyle: TextStyle(color: Colors.white24),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: Color(0xFF4D4EE8), width: 2),
                ),
              ),
              onTap: () {
                Future.delayed(
                  const Duration(milliseconds: 600),
                  () {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                );
              },
              onChanged: (value) => diaryProvider.setPrompt(value),
              style: const TextStyle(color: Colors.white),
              cursorColor: const Color(0xFF4D4EE8),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  FocusScope.of(context).unfocus();

                  await diaryProvider.generateImage(context);

                  if (context.mounted) {
                    context.push('/image-generation');
                  }
                },
                label: const Text(
                  'Generate New Image',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: const Color(0xFF4D4EE8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
