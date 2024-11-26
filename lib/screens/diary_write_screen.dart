import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diary_input_provider.dart';
import 'package:go_router/go_router.dart';

class DiaryWriteScreen extends StatefulWidget {
  const DiaryWriteScreen({super.key});

  @override
  State<DiaryWriteScreen> createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends State<DiaryWriteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _storyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final diaryProvider = Provider.of<DiaryInputProvider>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Today\'s Story'),
            centerTitle: true,
            scrolledUnderElevation: 0,
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
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
                  maxLength: 50,
                  onChanged: (value) => diaryProvider.setTitle(value),
                  cursorColor: const Color(0xFF4D4EE8),
                  decoration: const InputDecoration(
                    hintText: 'Title here',
                    hintStyle: TextStyle(color: Colors.white24),
                    counterStyle: TextStyle(color: Colors.white54),
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
                  maxLength: 500,
                  maxLines: 10,
                  onTap: () {
                    if (mounted) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    }
                  },
                  onChanged: (value) => diaryProvider.setContent(value),
                  cursorColor: const Color(0xFF4D4EE8),
                  decoration: const InputDecoration(
                    hintText: 'Write about your day',
                    hintStyle: TextStyle(color: Colors.white24),
                    counterStyle: TextStyle(color: Colors.white54),
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
                    Provider.of<DiaryInputProvider>(context, listen: false);
                await diaryProvider.generateImage(context);

                if (context.mounted) {
                  context.push('/image-generation');
                }
              },
              label: const Text(
                'Make it Visual',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              backgroundColor: const Color(0xFF4D4EE8),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ],
    );
  }
}
