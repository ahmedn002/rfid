import 'package:flutter/material.dart';

class DateUtilities {
  static String formatTime(DateTime time) {
    String hour = time.hour.toString();
    String minute = time.minute.toString();
    String amPm = 'AM';

    if (time.hour > 12) {
      hour = (time.hour - 12).toString();
      amPm = 'PM';
    }

    if (time.hour == 0) {
      hour = '12';
    }

    if (time.minute < 10) {
      minute = '0$minute';
    }

    return '$hour:$minute $amPm';
  }

  // datetime to time of day
  static TimeOfDay dateToTimeOfDay(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  static String formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  static String formatDateTime(DateTime date) {
    return '${date.year}/${date.month}/${date.day} - ${formatTime(date)}';
  }
}
