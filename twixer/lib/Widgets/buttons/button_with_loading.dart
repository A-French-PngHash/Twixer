import 'package:flutter/material.dart';
import 'package:twixer/Widgets/other/twixer_loading_indicator.dart';

/// A button that implements a specific loading state.
class ButtonWithLoading extends StatelessWidget {
  final bool loading;
  final Widget child;
  final onPressed;

  ButtonWithLoading({required this.loading, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SizedBox(
        width: 30,
        height: 70,
        child: TwixerLoadingIndicator(),
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        child: child,
      );
    }
  }
}
