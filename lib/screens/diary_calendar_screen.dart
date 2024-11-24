import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vivid_diary/widgets/diary_list.dart';
import 'package:vivid_diary/providers/diary_provider.dart';
import 'package:provider/provider.dart';
import 'package:vivid_diary/providers/diary_input_provider.dart';

class DiaryCalendarScreen extends StatefulWidget {
  const DiaryCalendarScreen({super.key});

  @override
  State<DiaryCalendarScreen> createState() => _DiaryCalendarScreenState();
}

class _DiaryCalendarScreenState extends State<DiaryCalendarScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildCalendar(context),
            const Expanded(
              child: RecentDiaryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    const textColor = Color(0xFFD6D7DC);

    final diaryProvider = context.watch<DiaryProvider>();
    final diaryInputProvider = context.watch<DiaryInputProvider>();
    return TableCalendar(
      firstDay: DateTime.utc(2021, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: diaryProvider.focusedDate,
      selectedDayPredicate: (day) {
        return isSameDay(diaryProvider.selectedDate, day);
      },
      onDaySelected: (selectedDay, focusedDay) async {
        await diaryProvider.setSelectedDate(selectedDay);
        diaryInputProvider.setDate(selectedDay.toString());
      },
      onPageChanged: (focusedDay) async {
        final diaryProvider = context.read<DiaryProvider>();
        await diaryProvider.setFocusedDate(focusedDay);
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
        // 오늘 날짜 데코레이션 제거
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        todayTextStyle: TextStyle(color: textColor),
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
        markerBuilder: (context, day, events) {
          final isWeekend = day.weekday == DateTime.saturday ||
              day.weekday == DateTime.sunday;

          return _buildCalendarCell(diaryProvider.diaryDates, day,
              isSameDay(diaryProvider.selectedDate, day), isWeekend);
        },
      ),
    );
  }

  Widget? _buildCalendarCell(
      List<int> diaryDates, DateTime date, bool isSelected, bool isWeekend) {
    if (diaryDates.contains(date.day) && !isSelected) {
      return Container(
        margin: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFFFAF7E),
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Center(
      child: Text(
        '${date.day}',
        style: TextStyle(
          color: (isWeekend && !isSelected)
              ? const Color(0xFFF74D4D)
              : const Color(0xFFD6D7DC),
        ),
      ),
    );
  }
}
