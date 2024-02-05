import 'package:flutter/material.dart';
import 'package:lab3/views/exam_terms_view.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/ExamTerm.dart';

class CalendarView extends StatefulWidget {
  final List<ExamTerm> exams;

  const CalendarView({super.key, required this.exams});

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<ExamTerm> _selectedExams = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime(DateTime.now().year + 5),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: (day) {
              // Load events for the specified day
              return widget.exams
                  .where((exam) => isSameDay(exam.dateTime, day))
                  .toList();
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedExams = widget.exams
                      .where((exam) => isSameDay(exam.dateTime, selectedDay))
                      .toList();
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedExams.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(_selectedExams[index].subject),
                    subtitle: Text(
                        "Time: ${_selectedExams[index].time}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}