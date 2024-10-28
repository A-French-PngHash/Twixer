import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataModel/tweet_model.dart';
import 'package:twixer/Widgets/cards/tweet_card.dart';
import 'package:twixer/Widgets/error_handler.dart';
import 'package:twixer/Widgets/painters/vertical_line_painter.dart';

class Response extends StatefulWidget {
  final TweetModel initialTweet;
  final Connection? connection;

  const Response({required this.initialTweet, required this.connection, super.key});

  @override
  State<Response> createState() => _ResponseState();
}

class _ResponseState extends State<Response> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TweetCard(
            widget.initialTweet,
            widget.connection,
            ErrorHandler(context),
            clickable: false,
            style: TweetDisplayStyle.big,
          ),
        ],
      ),
    );
  }
}
