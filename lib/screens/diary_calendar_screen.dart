import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vivid_diary/models/diary_entry.dart';
import 'package:vivid_diary/widgets/diary_list.dart';

class DiaryCalendarScreen extends StatefulWidget {
  const DiaryCalendarScreen({super.key});

  @override
  State<DiaryCalendarScreen> createState() => _DiaryCalendarScreenState();
}

class _DiaryCalendarScreenState extends State<DiaryCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  // 테스트용 데이터
  final Map<DateTime, String> _diaryImages = {
    DateTime.utc(2024, 3, 15): 'https://picsum.photos/100',
    DateTime.utc(2024, 3, 20): 'https://picsum.photos/101',
    DateTime.utc(2024, 3, 25): 'https://picsum.photos/102',
  };

  final List<DiaryEntry> _diaryEntries = [
    DiaryEntry(
      id: '1',
      date: DateTime.now().subtract(const Duration(days: 1)),
      title: '즐거운 주말',
      content: '오늘은 친구들과 카페에서 만났다...',
      imageUrl: 'https://picsum.photos/200',
    ),
    DiaryEntry(
      id: '2',
      date: DateTime.now().subtract(const Duration(days: 3)),
      title: '비오는 날',
      content: '창밖에 빗소리를 들으며 책을 읽었다...',
      imageUrl: 'https://picsum.photos/201',
    ),
    DiaryEntry(
      id: '3',
      date: DateTime.now().subtract(const Duration(days: 3)),
      title: '비오는 날',
      content: '창밖에 빗소리를 들으며 책을 읽었다...',
      imageUrl: 'https://picsum.photos/201',
    ),
    DiaryEntry(
      id: '4',
      date: DateTime.now().subtract(const Duration(days: 3)),
      title: '비오는 날',
      content: '창밖에 빗소리를 들으며 책을 읽었다...',
      imageUrl: 'https://picsum.photos/201',
    ),
  ];

  bool isSameDate(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildCalendar(),
            Expanded(
              child: RecentDiaryList(diaries: _diaryEntries),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    const textColor = Color(0xFFD6D7DC);

    return TableCalendar(
      firstDay: DateTime.utc(2021, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      calendarStyle: const CalendarStyle(
        // 날짜 스타일
        defaultTextStyle: TextStyle(color: textColor),
        weekendTextStyle: TextStyle(color: Color(0xFFF74D4D)),
        outsideTextStyle: TextStyle(color: Color(0x80D6D7DC)), // 투명도 50%

        // 선택된 날짜 스타일
        selectedDecoration: BoxDecoration(
          color: Color(0xFF00D085),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(color: Color(0xFF04172C)),
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent, // 배경색 투명하게
        ),
        todayTextStyle: TextStyle(color: textColor), // 일반 날짜와 동일한 색상
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 17,
        ),
        leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
        rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: textColor),
        weekendStyle: TextStyle(color: textColor),
      ),
    );
  }

  Widget? _buildCalendarCell(DateTime day, bool isSelected) {
    for (DateTime date in _diaryImages.keys) {
      if (isSameDate(date, day)) {
        return Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: const Color(0xFFFFAF7E), width: 2)
                : null,
          ),
          child: ClipOval(
            child: Stack(
              children: [
                Image.network(
                  _diaryImages[date]!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    return null;
  }
}
