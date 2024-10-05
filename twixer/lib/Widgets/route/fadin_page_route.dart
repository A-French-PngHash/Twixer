import 'package:flutter/material.dart';

class FadingPageRoute<T> extends PageRoute<T> {
  FadingPageRoute(this.child);
  @override
  Color get barrierColor => Theme.of(navigator!.context).colorScheme.surface;

  @override
  String get barrierLabel => "test";

  final Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);
}
