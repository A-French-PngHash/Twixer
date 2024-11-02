import 'package:flutter/material.dart';

class ComingFromBottomRoute<T> extends PageRoute<T> {
  final Widget child;
  ComingFromBottomRoute(this.child);

  @override
  // TODO: implement barrierColor
  Color? get barrierColor => Theme.of(navigator!.context).colorScheme.surface;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => "test";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final begin = Offset(0.0, 1.0);
    final end = Offset(0.0, 0.0);
    final position = animation.drive(Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease)));
    return SlideTransition(
      position: position,
      child: child,
    );
  }

  @override
  // TODO: implement maintainState
  bool get maintainState => true;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(milliseconds: 200);
}

/*
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) {
    return WriteTweet(
      connection: this.connection,
    );
  },
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    
  },
  transitionDuration: Duration(milliseconds: 200)))
                  */

/* PageRouteBuilder(
pageBuilder: (context, animation, secondaryAnimation) {
  return WriteTweet(
    connection: this.connection,
  );
},
transitionsBuilder: (context, animation, secondaryAnimation, child) {
  final begin = Offset(0.0, 1.0);
  final end = Offset(0.0, 0.0);
  final position =
      animation.drive(Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease)));
  return SlideTransition(
    position: position,
    child: child,
  );
},
transitionDuration: Duration(milliseconds: 200))*/