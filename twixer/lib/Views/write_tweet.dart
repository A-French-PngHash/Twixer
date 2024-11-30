import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/actions.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataModel/tweet_model.dart';
import 'package:twixer/Views/profile.dart';
import 'package:twixer/Widgets/buttons/twixer_button.dart';
import 'package:twixer/Widgets/cards/tweet_card.dart';
import 'package:twixer/Widgets/notification/twixer_notification.dart';
import 'package:twixer/Widgets/other/error_handler.dart';
import 'package:twixer/Widgets/other/profile_picture.dart';
import 'package:twixer/config.dart';

class WriteTweet extends StatelessWidget {
  final Connection connection;
  late final ErrorHandler errorHandler;
  late final TextEditingController _controller;

  /// The context before the post view is to be displayed. This is used to
  /// display a notification when the user is back on this view once the tweet
  /// has been posted.
  final BuildContext initialContext;

  /// A tweet can be posted in response to another tweet.
  final TweetModel? respondingTo;
  final TweetModel? retweeting;

  WriteTweet(
      {required this.connection, this.respondingTo, this.retweeting, required BuildContext this.initialContext}) {
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
              this._controller.dispose();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
          ),
          actions: [
            TwixerButton(
              "Post",
              style: TwixerButtonStyle.filled,
              onPressed: () async {
                if (this._controller.text != "") {
                  if (this.retweeting != null) {
                    retweet(this.connection, this.retweeting!.id, this._controller.text).then((result) async {
                      await this.errorHandler.handle(result);
                      Navigator.of(this.initialContext).overlay!.insert(OverlayEntry(builder: (context) {
                        return TwixerNotification(text: "You tweet has been published.");
                      }));
                    });
                  } else {
                    postTweet(
                            connection, this._controller.text, this.respondingTo == null ? null : this.respondingTo!.id)
                        .then((result) async {
                      await this.errorHandler.handle(result);
                      Navigator.of(this.initialContext).overlay!.insert(OverlayEntry(builder: (context) {
                        return TwixerNotification(text: "You tweet has been published.");
                      }));
                    });
                  }

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.3),
              child: Container(
                color: GREY,
                height: 0.3,
              )),
        ),
        body: this.respondingTo != null
            ? responsePost(context, this.respondingTo!)
            : (this.retweeting != null ? retweetPost(context, this.retweeting!) : classicPost(context)));
  }

  /// Simple new tweet, not responding nor retweeting anything.
  Widget classicPost(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: buildTextField(context),
    );
  }

  Widget retweetPost(BuildContext context, TweetModel retweeting) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTextField(context, minLines: 1),
            Padding(
              padding: EdgeInsets.only(left: 50, right: 10),
              child: TweetCard(
                retweeting,
                this.connection,
                ErrorHandler(context),
                clickable: false,
                style: TweetDisplayStyle.retweetPreview,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tweet retweeting another one.
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

  Widget buildTextField(BuildContext context, {int minLines = 3}) {
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
            maxLength: 260,
            maxLines: null,
            minLines: minLines,
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
