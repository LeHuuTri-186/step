import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:step/extensions/app_localization_string_builder.dart';

class CustomCalendarPicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const CustomCalendarPicker({required this.onDateSelected});

  @override
  _CustomCalendarPickerState createState() => _CustomCalendarPickerState();
}

class _CustomCalendarPickerState extends State<CustomCalendarPicker> {
  DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildHeader(),
          _buildDaysOfWeek(),
          _buildDateGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final currentDate = DateTime.now();
    final isAtCurrentMonth = _focusedDate.year == currentDate.year &&
        _focusedDate.month == currentDate.month;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left),
            onPressed: isAtCurrentMonth
                ? null // Disable button if at the current month
                : () {
                    setState(() {
                      _focusedDate = DateTime(
                        _focusedDate.year,
                        _focusedDate.month - 1,
                      );
                    });
                  },
          ),
          Text(
            DateFormat.yMMMM(
              context.getLocaleString(
                value: 'locale',
              ),
            ).format(
              _focusedDate,
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: () {
              setState(
                () {
                  _focusedDate = DateTime(
                    _focusedDate.year,
                    _focusedDate.month + 1,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    const daysOfWeek = [
      "sun_short",
      "mon_short",
      "tue_short",
      "wed_short",
      "thu_short",
      "fri_short",
      "sat_short"
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: daysOfWeek
          .map((day) => Expanded(
                child: Center(
                  child: Text(
                    context.getLocaleString(
                      value: day,
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildDateGrid() {
    final daysInMonth =
        DateTime(_focusedDate.year, _focusedDate.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final today = DateTime.now();

    List<Widget> dayWidgets = [];

    // Empty slots before the first day of the month
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(
        Expanded(
            child: Container()), // Empty space for days before the first day
      );
    }

    // Days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedDate.year, _focusedDate.month, day);
      final isToday = date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
      final isPastDate = date.isBefore(today) && !isToday;

      dayWidgets.add(
        Expanded(
          child: GestureDetector(
            onTap: isPastDate
                ? null // Disable onTap if the date is in the past
                : () {
                    setState(() {
                      _selectedDate = date;
                      widget.onDateSelected(date);
                    });
                  },
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: _selectedDate == date
                    ? Colors.redAccent
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Center(
                  child: Text(
                    day.toString(),
                    style: GoogleFonts.varelaRound(
                      fontSize: 18,
                      color: isPastDate
                          ? Colors.grey // Grayed out for past dates
                          : (_selectedDate == date
                              ? Colors.white
                              : Colors.black),
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Add empty slots to complete the last row if necessary
    int remainingSlots = 7 - (dayWidgets.length % 7);
    if (remainingSlots < 7) {
      // Only add if there are incomplete slots
      for (int i = 0; i < remainingSlots; i++) {
        dayWidgets.add(Expanded(child: Container()));
      }
    }

    // Build rows of 7 days
    List<Row> weekRows = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      weekRows.add(Row(
        children: dayWidgets.sublist(i, i + 7),
      ));
    }

    return Column(children: weekRows);
  }
}
