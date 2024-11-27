import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:io';
import '../models/diary.dart';
import 'package:go_router/go_router.dart';
import '../providers/diary_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DiaryDetailScreen extends StatefulWidget {
  final int diaryId;

  const DiaryDetailScreen({
    Key? key,
    required this.diaryId,
  }) : super(key: key);

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  Diary? _diary;

  @override
  void initState() {
    super.initState();
    _loadDiary();
  }

  Future<void> _loadDiary() async {
    final provider = context.read<DiaryProvider>();
    final diary = await provider.getDiary(widget.diaryId);
    setState(() {
      _diary = diary;
      _titleController = TextEditingController(text: diary.title);
      _contentController = TextEditingController(text: diary.content);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_diary == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final provider = context.read<DiaryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Story'),
        centerTitle: true,
        backgroundColor: Colors.black,
        scrolledUnderElevation: 0,
        elevation: 0,
        actions: _isEditing
            ? [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                      _titleController.text = _diary!.title;
                      _contentController.text = _diary!.content;
                    });
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Color(0xFF4D4EE8))),
                ),
                TextButton(
                  onPressed: () async {
                    await provider.updateDiary(
                      id: _diary!.id,
                      title: _titleController.text,
                      content: _contentController.text,
                    );
                    final newDiary = await provider.getDiary(_diary!.id);
                    setState(() {
                      _diary = newDiary;
                      _isEditing = false;
                    });
                  },
                  child: const Text('Save',
                      style: TextStyle(color: Color(0xFF4D4EE8))),
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () async {
                    try {
                      if (await File(_diary!.imageLocalPath).exists()) {
                        await Share.shareXFiles(
                          [XFile(_diary!.imageLocalPath)],
                          text: '${_diary!.title}\n\n${_diary!.content}',
                          subject: _diary!.title,
                        );
                      } else {
                        debugPrint(
                            '로컬 이미지 파일을 찾을 수 없습니다: ${_diary!.imageLocalPath}');
                      }
                    } catch (e) {
                      debugPrint('공유 중 오류 발생: $e');
                    }
                  },
                ),
                PopupMenuButton<String>(
                  color: Colors.grey[850],
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      setState(() {
                        _isEditing = true;
                      });
                    } else if (value == 'delete') {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.grey[850],
                          title: const Text('Delete Diary',
                              style: TextStyle(color: Colors.white)),
                          content: const Text(
                              'Are you sure you want to delete this diary?',
                              style: TextStyle(color: Colors.white70)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await provider.deleteDiary(_diary!.id);
                        if (context.mounted) {
                          context.go('/home');
                        }
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Edit', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
      ),
      body: SingleChildScrollView(
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
                        FileImage(File(_diary!.imageLocalPath)), context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Image.file(
                          File(_diary!.imageLocalPath),
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
                            color: Colors.white70,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isEditing) ...[
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter title',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide:
                              BorderSide(color: Color(0xFF4D4EE8), width: 2),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _contentController,
                      maxLength: 1000,
                      maxLines: 10,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter content',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide:
                              BorderSide(color: Color(0xFF4D4EE8), width: 2),
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      _diary!.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('MMM d, yyyy EEE')
                          .format(DateTime.parse(_diary!.date)),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _diary!.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
