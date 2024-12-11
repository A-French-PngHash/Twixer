import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/actions.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/browsing.dart';
import 'package:twixer/Views/response.dart';
import 'package:twixer/Views/write_tweet.dart';
import 'package:twixer/Widgets/other/date_display.dart';
import 'package:twixer/Widgets/other/error_handler.dart';
import 'package:twixer/Widgets/other/profile_picture.dart';
import 'package:twixer/Widgets/route/coming_from_bottom_route.dart';
import 'package:twixer/config.dart';
import '../../DataModel/tweet_model.dart';
import '../buttons/icon_count_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TweetDisplayStyle {
  classic,
  big, // Used when showing responses to a tweet. The big style is set for the main tweet.
  retweetPreview,
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
  TweetModel? retweetModel;

  TweetState(this.tweetModel) {}

  @override
  void initState() {
    super.initState();
    if (this.tweetModel.retweetId != null) {
      getTweetFromId(tweetModel.retweetId!, connection: widget.connection).then((result) {
        setState(() {
          retweetModel = this.widget._handler.handle(result);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(0),
        shadowColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: Colors.grey,
        foregroundColor: Colors.black,
        disabledBackgroundColor: Colors.transparent,
        disabledForegroundColor: Colors.black,
        disabledIconColor: Colors.black,
        shape: widget.style == TweetDisplayStyle.retweetPreview
            ? RoundedRectangleBorder(
                side: BorderSide(width: 0.4, color: Colors.grey), borderRadius: BorderRadius.circular(15))
            : RoundedRectangleBorder(),
      ),
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
                size: this.widget.style == TweetDisplayStyle.retweetPreview ? 26 : 40,
                connection: this.widget.connection!,
                clickable: true,
              ),
            ),
            Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: buildMainColumnChildren()),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildMainColumnChildren() {
    final List<Widget> children = [
      Container(
        height: widget.style == TweetDisplayStyle.retweetPreview ? 8 : 0,
      ),
      Text(
        "@${tweetModel.authorUsername}",
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontSize: widget.style == TweetDisplayStyle.retweetPreview ? 17 : null),
      ),
      Text(
        tweetModel.content,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontSize: widget.style == TweetDisplayStyle.retweetPreview ? 15 : null),
      ),
    ];
    if (widget.style != TweetDisplayStyle.retweetPreview) {
      if (this.retweetModel != null) {
        children.add(TweetCard(
          this.retweetModel!,
          this.widget.connection,
          this.widget._handler,
          style: TweetDisplayStyle.retweetPreview,
        ));
      }
      children.add(DateDisplay(tweetModel.postDate));
    }
    if (widget.style == TweetDisplayStyle.classic) {
      children.add(buildClassicIconRow());
    }
    if (widget.style == TweetDisplayStyle.big) {
      children.add(buildBigIconRow());
    }

    return children;
  }

  void rebuildTweet() async {
    final result = widget._handler.handle(await getTweetFromId(tweetModel.id,
        connection: this.widget.connection)); // Fetching the tweet data from the server.
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
    final iconList = [
      IconCountButton(
          iconToggled: Icons.favorite,
          iconUntoggled: Icons.favorite_border,
          toggledColor: Colors.red,
          count: showCount ? tweetModel.likeCount : null,
          isToggled: (tweetModel.isLiked != null && tweetModel.isLiked == 1),
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
              postAnswerButtonPressed(context);
            }),
      ),
    ];
    if (this.tweetModel.authorId != this.widget.connection!.user_id) {
      iconList.add(IconCountButton(
          iconToggled: FontAwesomeIcons.retweet,
          iconUntoggled: FontAwesomeIcons.retweet,
          count: null,
          toggledColor: Color.fromARGB(255, 112, 230, 118),
          isToggled: (tweetModel.isRetweeted != null && tweetModel.isRetweeted == 1),
          size: size,
          onPressed: () {
            retweetButtonPressed(context);
          }));
    }

    return iconList;
  }

  void likeButtonPressed() {
    // Like the tweet.
    like_tweet(tweetModel.id, widget.connection).then((value) async {
      widget._handler.handle(value);
      // Like succeeded, we can update the tweet.
      rebuildTweet();
    });
  }

  void retweetButtonPressed(BuildContext context) {
    Navigator.of(context).push(ComingFromBottomRoute(WriteTweet(
      connection: widget.connection!,
      retweeting: this.tweetModel,
      initialContext: context,
    )));
  }

  void postAnswerButtonPressed(BuildContext context) {
    Navigator.of(context).push(ComingFromBottomRoute(WriteTweet(
      connection: widget.connection!,
      respondingTo: this.tweetModel,
      initialContext: context,
    )));
  }
}
