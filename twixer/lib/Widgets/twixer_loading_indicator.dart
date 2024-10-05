import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class TwixerLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      indicatorType: Indicator.ballPulseSync,
      colors: [Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary],
    );
  }
}
