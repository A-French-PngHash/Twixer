import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/actions.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataModel/tweet_model.dart';
import 'package:twixer/Views/profile.dart';
import 'package:twixer/Widgets/error_handler.dart';
import 'package:twixer/Widgets/profile_picture.dart';
import 'package:twixer/config.dart';

class WriteTweet extends StatelessWidget {
  final Connection connection;
  late final ErrorHandler errorHandler;
  late final TextEditingController _controller;

  /// A tweet can be posted in response to another tweet.
  final TweetModel? respondingTo;

  WriteTweet({required this.connection, this.respondingTo}) {
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
                      postTweet(connection, this._controller.text,
                              this.respondingTo == null ? null : this.respondingTo!.id)
                          .then((result) async {
                        await this.errorHandler.handle(result);
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    "Post",
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
        body: this.respondingTo == null ? classicPost(context) : responsePost(context, this.respondingTo!));
  }

  /// Simple new tweet, not responding nor retweeting anything.
  Widget classicPost(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: buildTextField(context),
    );
  }

  Widget responsePost(BuildContext context, TweetModel respondingTo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                color: GREY,
                width: 2,
                height: 30,
              ),
            ),
            Text("En réponse à"),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return ProfileView(
                    username: respondingTo.authorUsername,
                    errorHandler: ErrorHandler(context),
                    connection: this.connection,
                    provideReturnArrow: true,
                  );
                }));
              },
              child: Text("@${respondingTo.authorUsername}"),
              style: TextButton.styleFrom(overlayColor: Colors.transparent),
            ),
          ],
        ),
        buildTextField(context),
      ],
    );
  }

  Widget buildTextField(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfilePicture(
          username: connection.username!,
          handler: ErrorHandler(context),
          size: 40,
          connection: this.connection,
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.only(left: 10),
          child: TextField(
            controller: this._controller,
            autofocus: true,
            autocorrect: true,
            maxLength: 2600,
            maxLines: null,
            minLines: 3,
            decoration: InputDecoration(
              hintText: "What's on your mind ?",
              border: InputBorder.none,
            ),
          ),
        ))
      ],
    );
  }
}
