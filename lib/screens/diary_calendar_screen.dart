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
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Calendar',
          style: TextStyle(
            color: Color(0xFFA5A5A5),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildCalendar(),
          Expanded(
            child: RecentDiaryList(diaries: _diaryEntries),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2024, 12, 31),
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
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
        defaultTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
        weekendTextStyle: TextStyle(
          color: Colors.red,
          fontSize: 14,
        ),
        selectedTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        selectedDecoration: BoxDecoration(
          color: Color(0xFFFFAF7E),
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(),
        todayTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Color(0xFFCBB7A2),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        weekendStyle: TextStyle(
          color: Color(0xFFCBB7A2),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return _buildCalendarCell(day, false);
        },
        selectedBuilder: (context, day, focusedDay) {
          return _buildCalendarCell(day, true);
        },
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFA5A5A5),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Color(0xFFA5A5A5),
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Color(0xFFA5A5A5),
        ),
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
