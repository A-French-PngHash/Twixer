
import 'package:flutter/material.dart';
import 'package:twixer/config.dart';

/// A round button with a plus inside.
///
/// When the user clicks it opens the interface to write a tweet.
class NewTweetButton extends StatelessWidget {
  final void Function() onPressed;
  const NewTweetButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BLUE,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              blurRadius: 3, blurStyle: BlurStyle.normal, offset: Offset(0, 3), color: Colors.black.withOpacity(0.4)),
        ],
      ),
      child: FittedBox(
        child: IconButton(
          iconSize: 35,
          onPressed: onPressed,
          icon: Icon(Icons.add),
          color: Colors.white,
        ),
      ),
    );
  }
}
