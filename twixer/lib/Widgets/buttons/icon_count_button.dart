import 'package:flutter/material.dart';

class IconCountButton extends StatelessWidget {
  final IconData iconToggled;
  final IconData iconUntoggled;
  final Color? toggledColor;
  final int? count;
  final double? size;
  final bool isToggled;
  final Function() onPressed;

  const IconCountButton(
      {required this.iconToggled,
      required this.iconUntoggled,
      this.count,
      this.size,
      required this.isToggled,
      required this.onPressed,
      super.key,
      this.toggledColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            icon: Icon(
              isToggled ? iconToggled : iconUntoggled,
              color: isToggled ? this.toggledColor : null,
              size: size,
            ),
            onPressed: onPressed),
        Text(
          count == null ? "" : count.toString(),
        ),
      ],
    );
  }
}
