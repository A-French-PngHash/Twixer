import 'package:flutter/material.dart';

class TextFieldLikeButton extends StatelessWidget {
  String content;
  bool showCross;
  Function onPressed;

  TextFieldLikeButton(this.content, this.showCross, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.all(1),
              child:
                  Text(content, style: Theme.of(context).textTheme.labelMedium),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(1),
              child: Text(""),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1, color: Color.fromARGB(255, 212, 216, 217)),
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Color.fromARGB(255, 239, 243, 244),
            splashFactory: NoSplash.splashFactory,
            overlayColor: Colors.transparent),
      ),
    );
  }
}
