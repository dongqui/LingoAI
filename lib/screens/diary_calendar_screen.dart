import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vivid_diary/widgets/diary_list.dart';
import 'package:vivid_diary/providers/diary_provider.dart';
import 'package:provider/provider.dart';

class DiaryCalendarScreen extends StatefulWidget {
  const DiaryCalendarScreen({super.key});

  @override
  State<DiaryCalendarScreen> createState() => _DiaryCalendarScreenState();
}

class _DiaryCalendarScreenState extends State<DiaryCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Provider getter 추가
  DiaryProvider get _diaryProvider =>
      Provider.of<DiaryProvider>(context, listen: false);

  // 테스트용 데이터
  final Map<DateTime, String> _diaryImages = {
    DateTime.utc(2024, 3, 15): 'https://picsum.photos/100',
    DateTime.utc(2024, 3, 20): 'https://picsum.photos/101',
    DateTime.utc(2024, 3, 25): 'https://picsum.photos/102',
  };

  @override
  void initState() {
    super.initState();
    _diaryProvider.getDiariesForDate(_diaryProvider.selectedDate);
  }

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
              child: RecentDiaryList(diaries: _diaryProvider.diaries),
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
      focusedDay: _diaryProvider.focusedDate,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_diaryProvider.selectedDate, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _diaryProvider.setSelectedDate(selectedDay);
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
          color: Color(0xFF4D4EE1),
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
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return _buildCalendarCell(
              day, isSameDay(_diaryProvider.selectedDate, day));
        },
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '${day.day}',
                style: const TextStyle(
                  color: Color(0xFFD6D7DC),
                ),
              ),
              const Positioned(
                bottom: 2,
                child: Icon(
                  Icons.star,
                  size: 8,
                  color: Color(0xFFFFAF7E),
                ),
              ),
            ],
          ),
        );
      }
    }
    return null;
  }
}
