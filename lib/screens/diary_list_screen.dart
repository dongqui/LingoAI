import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import 'diary_write_screen.dart';

class DiaryListScreen extends StatefulWidget {
  const DiaryListScreen({super.key});

  @override
  State<DiaryListScreen> createState() => _DiaryListScreenState();
}

class _DiaryListScreenState extends State<DiaryListScreen> {
  List<DiaryEntry> diaries = [
    DiaryEntry(
      id: '1',
      title: '즐거운 주말',
      content: '오늘은 친구들과 놀이공원에 다녀왔다. 롤러코스터도 타고 맛있는 것도 많이 먹었다. 정말 재미있었다!',
      date: DateTime.now().subtract(const Duration(days: 1)),
      imageUrl: 'https://picsum.photos/200', // 임시 이미지
    ),
    DiaryEntry(
      id: '2',
      title: '비오는 날',
      content: '오늘은 하루종일 비가 왔다. 창밖을 보며 책을 읽었는데, 비오는 날의 여유가 참 좋았다.',
      date: DateTime.now().subtract(const Duration(days: 2)),
      imageUrl: 'https://picsum.photos/201', // 임시 이미지
    ),
    DiaryEntry(
      id: '3',
      title: '새로운 취미',
      content: '요즘 그림 그리기를 시작했다. 아직은 서툴지만 하나씩 배워가는 게 재미있다.',
      date: DateTime.now().subtract(const Duration(days: 3)),
      imageUrl: 'https://picsum.photos/202', // 임시 이미지
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('나의 그림 일기'),
      ),
      body: diaries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '아직 작성된 일기가 없습니다.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: diaries.length,
              itemBuilder: (context, index) {
                final diary = diaries[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.network(
                              diary.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                diary.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                diary.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
