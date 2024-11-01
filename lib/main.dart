import 'package:flutter/material.dart';
import 'screens/diary_list_screen.dart';

void main() {
  runApp(const DiaryApp());
}

class DiaryApp extends StatelessWidget {
  const DiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 그림 일기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DiaryListScreen(),
    );
  }
}
