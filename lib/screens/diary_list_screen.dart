import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import 'diary_write_screen.dart';

class DiaryListScreen extends StatefulWidget {
  const DiaryListScreen({super.key});

  @override
  State<DiaryListScreen> createState() => _DiaryListScreenState();
}

class _DiaryListScreenState extends State<DiaryListScreen> {
  List<DiaryEntry> diaries = []; // 나중에 DB에서 가져올 예정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 그림 일기'),
      ),
      body: diaries.isEmpty
          ? const Center(
              child: Text('아직 작성된 일기가 없습니다.'),
            )
          : ListView.builder(
              itemCount: diaries.length,
              itemBuilder: (context, index) {
                final diary = diaries[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(diary.title),
                    subtitle: Text(
                      diary.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: diary.imageUrl != null
                        ? SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(
                              diary.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.image_not_supported),
                          ),
                    onTap: () {
                      // 일기 상세 보기 화면으로 이동
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DiaryWriteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
