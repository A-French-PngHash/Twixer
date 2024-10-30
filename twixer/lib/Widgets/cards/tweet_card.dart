import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/actions.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/browsing.dart';
import 'package:twixer/Views/response.dart';
import 'package:twixer/Widgets/date_display.dart';
import 'package:twixer/Widgets/error_handler.dart';
import 'package:twixer/Widgets/profile_picture.dart';
import 'package:twixer/config.dart';
import '../../DataModel/tweet_model.dart';
import '../buttons/icon_count_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TweetDisplayStyle {
  classic,
  big // Used when showing responses to a tweet. The big style is set for the main tweet.
}

class TweetCard extends StatefulWidget {
  final Connection? connection;
  final ErrorHandler _handler;
  final TweetModel initialTweetModel;
  final bool clickable;

  final TweetDisplayStyle style;

  /// Initialization
  ///
  /// [initialTweetModel] : The TweetModel when the Tweet is first displayed.
  /// Depending on what the user does, the tweetModel might change (thus
  /// "initial")
  /// [clickable] : Whether the reponse screen should be shown when the tweet is
  /// clicked.
  TweetCard(this.initialTweetModel, this.connection, this._handler,
      {super.key, this.clickable = true, this.style = TweetDisplayStyle.classic}) {}

  @override
  State<StatefulWidget> createState() {
    return TweetState(initialTweetModel);
  }
}

class TweetState extends State<TweetCard> {
  TweetModel tweetModel;

  TweetState(this.tweetModel);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.grey,
          foregroundColor: Colors.black,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: Colors.black,
          disabledIconColor: Colors.black,
          shape: RoundedRectangleBorder()),
      onPressed: widget.clickable
          ? () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return Response(initialTweet: this.tweetModel, connection: widget.connection);
              }));
              rebuildTweet();
            }
          : null,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10, top: 10),
              child: ProfilePicture(
                username: tweetModel.authorUsername,
                handler: ErrorHandler(context),
                size: 40,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "@${tweetModel.authorUsername}",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    tweetModel.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  DateDisplay(tweetModel.postDate),
                  widget.style == TweetDisplayStyle.classic ? buildClassicIconRow() : buildBigIconRow()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void rebuildTweet() async {
    final result =
        widget._handler.handle(await getTweetFromId(tweetModel.id)); // Fetching the tweet data from the server.
    if (result != null) {
      setState(() {
        // Updating tweet data on the interface.
        tweetModel = result;
      });
    }
  }

  Widget buildClassicIconRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: getIconList(showCount: true),
    );
  }

  Widget buildBigIconRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: GREY,
          thickness: 0.5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child:
                    Text(this.tweetModel.numberOfResponse.toString(), style: Theme.of(context).textTheme.headlineSmall),
              ),
              Text("responses"),
            ]),
            Row(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(this.tweetModel.likeCount.toString(), style: Theme.of(context).textTheme.headlineSmall),
              ),
              Text("likes"),
            ]),
          ],
        ),
        Divider(
          color: GREY,
          thickness: 0.5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: getIconList(showCount: false, size: 30),
        ),
      ],
    );
  }

  List<Widget> getIconList({required bool showCount, double? size}) {
    return [
      IconCountButton(
          iconToggled: Icons.favorite,
          iconUntoggled: Icons.favorite_border,
          toggledColor: Colors.red,
          count: showCount ? tweetModel.likeCount : null,
          isToggled: tweetModel.isLiked == 1,
          size: size,
          onPressed: () {
            likeButtonPressed();
          }),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: IconCountButton(
            iconToggled: Icons.mode_comment,
            iconUntoggled: Icons.mode_comment_outlined,
            count: showCount ? tweetModel.numberOfResponse : null,
            isToggled: true,
            size: size,
            onPressed: () {
              postAnswerButtonPressed();
            }),
      ),
      IconCountButton(
          iconToggled: FontAwesomeIcons.retweet,
          iconUntoggled: FontAwesomeIcons.retweet,
          count: null,
          isToggled: false,
          size: size,
          onPressed: () {
            retweetButtonPressed();
          })
    ];
  }

  void likeButtonPressed() {
    // Like the tweet.
    like_tweet(tweetModel.id, widget.connection).then((value) async {
      widget._handler.handle(value);
      // Like succeeded, we can update the tweet.
      rebuildTweet();
    });
    print("Like");
  }

  void retweetButtonPressed() {
    // SHOW RETWEET SCREEN
  }

  void postAnswerButtonPressed() {
    // POSTER LA REPONSE DE LUTILISATEUR
  }
}
