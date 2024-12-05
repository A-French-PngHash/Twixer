import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/browsing.dart';
import 'package:twixer/DataModel/enums/order_by.dart';
import 'package:twixer/DataModel/tweet_model.dart';
import 'package:twixer/Widgets/cards/tweet_card.dart';
import 'package:twixer/Widgets/displayers/tweet_displayer.dart';
import 'package:twixer/Widgets/other/error_handler.dart';
import 'package:twixer/Widgets/response_order_dropdown/response_order_dropdown.dart';

class Response extends StatefulWidget {
  final TweetModel initialTweet;
  final Connection? connection;

  const Response({required this.initialTweet, required this.connection, super.key});

  @override
  State<Response> createState() => _ResponseState();
}

class _ResponseState extends State<Response> {
  OrderBy selectedOrder = OrderBy.date;

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
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: ResponseOrderDropdown(onSelect: (selected) {
                  setState(() {
                    this.selectedOrder = selected;
                  });
                })),
          ),
          Expanded(
            child: TweetDisplayer(
              get: (limit, offset) async {
                return await getResponseTweet(widget.initialTweet.id, limit, offset, this.selectedOrder,
                    connection: this.widget.connection);
              },
              connection: widget.connection,
              key: UniqueKey(),
            ),
          ),
        ],
      ),
    );
  }
}
