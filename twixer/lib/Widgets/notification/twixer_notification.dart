import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:twixer/config.dart';

class TwixerNotification extends StatefulWidget {
  final String text;
  final Duration dismissAfter;
  const TwixerNotification({super.key, required this.text, this.dismissAfter = const Duration(seconds: 2)});

  @override
  State<TwixerNotification> createState() => _TwixerNotificationState();
}

class _TwixerNotificationState extends State<TwixerNotification> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> position;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 750));

    position = Tween<Offset>(begin: Offset(0.0, -4.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInCubic));

    controller.forward();

    Future.delayed(this.widget.dismissAfter).then((val) {
      controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 32.0, left: 10, right: 10),
            child: SlideTransition(
              position: position,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(color: BLUE, spreadRadius: 0.5),
                    ],
                    color: Color.lerp(BLUE, Colors.white, 0.8)),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 30, top: 10, bottom: 10),
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: BLUE),
                        ),
                      ),
                      Text(
                        this.widget.text,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
