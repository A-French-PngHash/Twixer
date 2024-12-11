import 'package:flutter/material.dart';
import 'package:twixer/config.dart';

enum TwixerButtonStyle { filled, outlined }

class TwixerButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final TwixerButtonStyle style;

  const TwixerButton(this.text, {super.key, this.onPressed, required this.style});

  @override
  Widget build(BuildContext context) {
    final filledDecoration = BoxDecoration(
      color: BLUE,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
    final outlinedDecoration = BoxDecoration(
      color: Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: BLUE, width: 1),
    );
    return Container(
      padding: EdgeInsets.only(right: 20),
      child: Container(
        height: 37,
        decoration: this.style == TwixerButtonStyle.filled ? filledDecoration : outlinedDecoration,
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            textStyle: Theme.of(context).textTheme.bodyLarge!,
          ),
          onPressed: this.onPressed,
          child: Text(
            this.text,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w900,
                  color: style == TwixerButtonStyle.filled ? Colors.white : Colors.black,
                ),
          ),
        ),
      ),
    );
  }
}
