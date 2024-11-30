import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/browsing.dart';
import 'package:twixer/DataModel/enums/order_by.dart';
import 'package:twixer/DataModel/tweet_model.dart';
import 'package:twixer/Widgets/cards/tweet_card.dart';
import 'package:twixer/Widgets/displayers/tweet_displayer.dart';
import 'package:twixer/Widgets/other/error_handler.dart';

class Response extends StatefulWidget {
  final TweetModel initialTweet;
  final Connection? connection;

  const Response({required this.initialTweet, required this.connection, super.key});

  @override
  State<Response> createState() => _ResponseState();
}

class _ResponseState extends State<Response> {
  OrderBy dropDownButtonValue = OrderBy.date;

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
            child: DropdownButton(
                focusColor: Colors.white,
                borderRadius: BorderRadius.zero,
                underline: Container(),
                elevation: 0,
                isDense: true,
                value: dropDownButtonValue,
                items: OrderBy.values.map((t) => DropdownMenuItem(child: Text(t.screenDisplay), value: t)).toList(),
                onChanged: (newVal) {
                  if (newVal != null) {
                    setState(() {
                      this.dropDownButtonValue = newVal;
                    });
                  }
                }),
          ),
          Expanded(
            child: TweetDisplayer(
              get: (limit, offset) async {
                return await getResponseTweet(widget.initialTweet.id, limit, offset, this.dropDownButtonValue,
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
