class DateTimeUtil {
  static bool isSameDay(DateTime date1, DateTime date2) =>
      date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;

  static bool isDayBefore(DateTime day1, DateTime day2) => DateTime(day1.year, day1.month, day1.day)
        .isBefore(DateTime(day2.year, day2.month, day2.day));

  static bool isDayAfter(DateTime day1, DateTime day2) => DateTime(day1.year, day1.month, day1.day)
      .isAfter(DateTime(day2.year, day2.month, day2.day));
}
