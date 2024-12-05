import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  final Widget child;
  final double size;
  final Function()? onTap;

  BaseButton({required this.child, this.onTap, this.size = 15});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: this.size,
                    ),
                child: child),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
