import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataModel/profile_card_model.dart';
import 'package:twixer/DataModel/tweet_model.dart';
import 'package:twixer/DataModel/user_model.dart';
import 'package:twixer/Widgets/cards/profile_card.dart';
import 'package:twixer/Widgets/cards/tweet_card.dart';
import 'package:twixer/Widgets/displayers/displayer.dart';
import 'package:twixer/Widgets/error_handler.dart';

class ProfileDisplayer extends StatelessWidget {
  final Future<(bool, List<ProfileCardModel>?, String?)> Function(
      int limit, int offset) get;
  final Connection? connection;
  late final ErrorHandler _handler;

  ProfileDisplayer({required this.get, required this.connection, super.key});

  @override
  Widget build(BuildContext context) {
    _handler = ErrorHandler(context);
    return Displayer<ProfileCardModel>(
      buildWidget: (dynamic value) {
        return ProfileCard(
          value,
          _handler,
        );
      },
      get: get,
      showRetry: false,
    );
  }
}
