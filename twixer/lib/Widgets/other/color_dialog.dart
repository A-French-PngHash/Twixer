import 'package:flutter/material.dart';

Widget buildColorDialog(BuildContext context, TextEditingController controller) {
  return AlertDialog(
    title: Text("Enter HEX color"),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "#",
          style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 25),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            width: 100,
            child: TextField(
              controller: controller,
              maxLength: 6,
              autocorrect: false,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 25),
              decoration: InputDecoration(
                  hintText: "1DA1F2",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  counterText: ""),
            ))
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        child: Text("Annuler"),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(true);
        },
        child: Text("Ok"),
      )
    ],
  );
}
