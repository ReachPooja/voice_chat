import 'package:intl/intl.dart';

String dateFormatter(int milliseconds) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  final now = DateTime.now();

  final difference = now.difference(dateTime);

  if (difference.inHours < 24) {
    if (now.day == dateTime.day) {
      return DateFormat.jm().format(dateTime);
    } else {
      return 'yesterday';
    }
  } else {
    return DateFormat('dd MMM').format(dateTime);
  }
}
