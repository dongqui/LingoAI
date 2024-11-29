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
  void initState() {
    super.initState();
    _titleController.addListener(_onTextChanged);
    _storyController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTextChanged);
    _storyController.removeListener(_onTextChanged);
    _titleController.dispose();
    _storyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  bool get _isFormValid =>
      _titleController.text.trim().isNotEmpty &&
      _storyController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final diaryProvider = Provider.of<DiaryInputProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (_titleController.text.trim().isNotEmpty ||
            _storyController.text.trim().isNotEmpty) {
          final bool shouldPop = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'Discard changes?',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'If you go back, your current content will be lost.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  backgroundColor: const Color(0xFF2D2D2D),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        'Discard',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ) ??
              false;

          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Stack(
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
                onPressed: _isFormValid
                    ? () async {
                        FocusScope.of(context).unfocus();
                        final diaryProvider = Provider.of<DiaryInputProvider>(
                            context,
                            listen: false);
                        await diaryProvider.generateImage(context);
                      }
                    : null,
                label: const Text(
                  'Make it Visual',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                backgroundColor:
                    _isFormValid ? const Color(0xFF4D4EE8) : Colors.grey,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        ],
      ),
    );
  }
}
