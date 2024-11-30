import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataModel/tweet_model.dart';
import 'package:twixer/Widgets/cards/tweet_card.dart';
import 'package:twixer/Widgets/displayers/displayer.dart';
import 'package:twixer/Widgets/other/error_handler.dart';

class TweetDisplayer extends StatelessWidget {
  final Future<(bool, List<TweetModel>?, String?)> Function(int limit, int offset) get;
  final Connection? connection;
  late final ErrorHandler _handler;

  TweetDisplayer({required this.get, required this.connection, super.key});

  @override
  Widget build(BuildContext context) {
    _handler = ErrorHandler(context);
    return Displayer<TweetModel>(
      buildWidget: (dynamic value) {
        return TweetCard(
          value,
          connection,
          _handler,
        );
      },
      get: get,
      showRetry: true,
    );
  }
}
