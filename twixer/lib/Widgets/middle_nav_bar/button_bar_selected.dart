import 'package:flutter/material.dart';

class ButtonBarSelected extends StatelessWidget {
  bool selected;
  String content;
  void Function() onPressed;
  ButtonBarSelected(
      {required this.selected, required this.content, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        content,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            shadows: [Shadow(color: Colors.black, offset: Offset(0, -10))],
            color: Colors.transparent,
            decoration: TextDecoration.underline,
            //backgroundColor: Theme.of(context).colorScheme.primary,
            decorationColor: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            decorationThickness: 4,
            decorationStyle: TextDecorationStyle.solid,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal),
      ),
      style: TextButton.styleFrom(overlayColor: Colors.transparent),
    );
  }
}
