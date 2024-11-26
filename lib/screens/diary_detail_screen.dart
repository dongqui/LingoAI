import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:io';
import '../models/diary.dart';
import 'package:go_router/go_router.dart';
import '../providers/diary_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DiaryDetailScreen extends StatelessWidget {
  final Diary diary;

  const DiaryDetailScreen({
    Key? key,
    required this.diary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DiaryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Story'),
        centerTitle: true,
        backgroundColor: Colors.black,
        scrolledUnderElevation: 0,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              try {
                if (await File(diary.imageLocalPath).exists()) {
                  await Share.shareXFiles(
                    [XFile(diary.imageLocalPath)],
                    text: '${diary.title}\n\n${diary.content}',
                    subject: diary.title,
                  );
                } else {
                  debugPrint('로컬 이미지 파일을 찾을 수 없습니다: ${diary.imageLocalPath}');
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
                context.go('/edit/${diary.id}');
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
                  await provider.deleteDiary(diary.id);
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
                    future:
                        precacheImage(NetworkImage(diary.imageUrl), context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Image.network(
                          diary.imageUrl,
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
                  Text(
                    diary.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    DateFormat('MMM d, yyyy (EEE)')
                        .format(DateTime.parse(diary.date)),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    diary.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
