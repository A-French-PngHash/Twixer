import 'package:flutter/material.dart';
import 'package:twixer/Widgets/middle_nav_bar/button_bar_selected.dart';

class MiddleNavBar extends StatefulWidget {
  List<String> labels;
  Function(int) onSelect;

  MiddleNavBar({required this.labels, required this.onSelect});

  @override
  State<StatefulWidget> createState() {
    return MiddleNavBarState(0);
  }
}

class MiddleNavBarState extends State<MiddleNavBar> {
  int _selectedIndex;

  MiddleNavBarState(this._selectedIndex);

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetList = [];

    for (var i = 0; i < widget.labels.length; i++) {
      widgetList.add(ButtonBarSelected(
          selected: (i == _selectedIndex),
          content: widget.labels[i],
          onPressed: () {
            setState(() {
              _selectedIndex = i;
            });
            widget.onSelect(i);
          }));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: widgetList,
      ),
    );
  }
}
