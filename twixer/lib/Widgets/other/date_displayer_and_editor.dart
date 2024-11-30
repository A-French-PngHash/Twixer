import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Displays the given date and allows editing of the date when the widget is
/// tapped by then displaying a date picker.
///
/// If no date is specified a date can still be picked.
class DateDisplayerAndEditor extends StatelessWidget {
  final DateTime? date;
  final void Function(DateTime)? onDatePicked;

  DateDisplayerAndEditor(this.date, {super.key, this.onDatePicked}) {
    print("Date displayer and editor");
    print(this.date);
  }

  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await showDatePicker(
            context: context, firstDate: DateTime(1900), lastDate: DateTime.now(), currentDate: this.date);
        if (this.onDatePicked != null && result != null) {
          this.onDatePicked!(result);
        }
      },
      child: this.date == null ? buildNoDateDisplay(context) : buildDateDisplay(context),
      style: ElevatedButton.styleFrom(elevation: 0, overlayColor: Colors.transparent, shadowColor: Colors.transparent),
    );
  }

  Widget buildNoDateDisplay(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [Text("Enter birth date...", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20))],
      ),
    );
  }

  Widget buildDateDisplay(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            date!.day.toString(),
            style: style,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              DateFormat.MMM().format(date!),
              style: style,
            ),
          ),
          Text(
            date!.year.toString(),
            style: style,
          ),
        ],
      ),
    );
  }
}
