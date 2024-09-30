import 'package:flutter/material.dart';

class DateTimeUtils {
  static String formatDateTime(
      {required BuildContext context, required String time}) {
    final datetime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    return TimeOfDay.fromDateTime(datetime).format(context);
  }

  // get last active time
  static String getLastuserActiveTime({
    required BuildContext context,
    required String lastActive,
  }) {
    // Safely parse the string to an integer
    final int i = int.tryParse(lastActive) ?? -1;

    // Check if the parsing failed
    if (i == -1) {
      return 'last seen not available';
    }

    // Convert the timestamp into a DateTime object
    final time = DateTime.fromMillisecondsSinceEpoch(i);
    final DateTime now = DateTime.now();

    // Format time for display
    String formatTime = TimeOfDay.fromDateTime(time).format(context);

    // Check if lastActive is from today
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return 'last seen today at $formatTime';
    }

    // Check if lastActive was yesterday
    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'last seen yesterday at $formatTime';
    }

    // Format date and time for other days
    String month = _getMonth(time);
    return 'last seen ${time.day} $month on $formatTime';
  }

  static String getLastMessageTime(
      {required BuildContext context,
      required String time,
      bool year = false}) {
    final sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (sent.day == now.day &&
        sent.month == now.month &&
        sent.year == now.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return year
        ? '${sent.day} :  ${_getMonth(sent)} ${sent.year}'
        : '${sent.day} :  ${_getMonth(sent)}';
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'Na';
  }
}
