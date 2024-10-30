import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/actions.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/Widgets/error_handler.dart';
import 'package:twixer/config.dart';

class WriteTweet extends StatelessWidget {
  final Connection connection;
  late final ErrorHandler errorHandler;
  late final TextEditingController _controller;

  WriteTweet({required this.connection}) {
    this._controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    errorHandler = ErrorHandler(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child: Container(
              decoration: BoxDecoration(
                color: BLUE,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextButton(
                onPressed: () async {
                  if (this._controller.text != "") {
                    postTweet(connection, this._controller.text, null).then((result) async {
                      await this.errorHandler.handle(result);
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  "Poster",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.3),
            child: Container(
              color: GREY,
              height: 0.3,
            )),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          controller: this._controller,
          autofocus: true,
          autocorrect: true,
          maxLength: 260,
          maxLines: null,
          minLines: 3,
          decoration: InputDecoration(
            hintText: "What's on your mind ?",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
