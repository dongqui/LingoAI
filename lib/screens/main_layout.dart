import 'package:flutter/material.dart';
import 'diary_list_screen.dart';
import 'diary_write_screen.dart';
import 'diary_calendar_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // 바텀 네비게이션 인덱스를 상수로 정의
  static const int HOME_TAB_INDEX = 0;
  static const int WRITE_TAB_INDEX = 1;
  static const int CALENDAR_TAB_INDEX = 2;

  void _onBottomNavTapped(int index) {
    if (index == WRITE_TAB_INDEX) {
      // Write 탭을 눌렀을 때 새로운 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DiaryWriteScreen()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  // 실제 표시될 페이지 리스트 (Write 페이지 제외)
  final List<Widget> _navigationPages = [
    const DiaryListScreen(), // HOME_TAB_INDEX: 0
    const DiaryCalendarScreen(), // CALENDAR_TAB_INDEX: 2
  ];

  @override
  Widget build(BuildContext context) {
    // Calendar 탭 선택 시 navigationPages의 두 번째 페이지(인덱스 1)를 보여줌
    final int pageIndex = _currentIndex == CALENDAR_TAB_INDEX ? 1 : 0;

    return Scaffold(
      body: _navigationPages[pageIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: '',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFFCB9735),
          unselectedItemColor: const Color(0xFFD7C9B8),
          backgroundColor: Colors.transparent,
          onTap: _onBottomNavTapped,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}
