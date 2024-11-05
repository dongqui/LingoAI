import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/diary_calendar_screen.dart';

void main() {
  runApp(const DiaryApp());
}

class DiaryApp extends StatelessWidget {
  const DiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vivid Diary',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF050B28),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.black12),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade100,
          foregroundColor: Colors.blue.shade700,
        ),
        fontFamily: GoogleFonts.singleDay().fontFamily,
      ),
      home: const DiaryCalendarScreen(),
    );
  }
}
