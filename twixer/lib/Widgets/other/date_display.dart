import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Displays the given date as a single text line.
class DateDisplay extends StatelessWidget {
  /// Microseconds since epoch.
  final int timestamp;

  late final DateTime postDate;

  DateDisplay(this.timestamp) {
    postDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${DateFormat("hh:mm").format(postDate)} · ${DateFormat("MMMM").format(postDate)} ${postDate.day}, ${postDate.year}",
          style: Theme.of(context).textTheme.labelMedium,
        )
      ],
    );
  }
}
