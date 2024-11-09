import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/diary_calendar_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/diary_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DiaryProvider()),
      ],
      child: const DiaryApp(),
    ),
  );
}

class DiaryApp extends StatelessWidget {
  const DiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardTheme(
          color: Color(0xFF141414),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4D4EE8),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D085),
          surface: Color(0xFF2A2A2A),
          background: Color(0xFF1A1A1A),
        ),
      ),
      home: const DiaryCalendarScreen(),
    );
  }
}
