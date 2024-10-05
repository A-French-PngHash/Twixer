import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/actions.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/browsing.dart';
import 'package:twixer/Widgets/date_display.dart';
import 'package:twixer/Widgets/error_handler.dart';
import 'package:twixer/Widgets/profile_picture.dart';
import '../../DataModel/tweet_model.dart';
import '../buttons/icon_count_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TweetCard extends StatefulWidget {
  final Connection? connection;
  final ErrorHandler _handler;
  final TweetModel initialTweetModel;
  TweetCard(this.initialTweetModel, this.connection, this._handler, {super.key}) {}

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: ProfilePicture(
            username: tweetModel.authorUsername,
            handler: ErrorHandler(context),
            size: 40,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "@${tweetModel.authorUsername}",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              tweetModel.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            DateDisplay(tweetModel.postDate),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // TODO : Get the isToggled from API
                IconCountButton(
                    iconToggled: Icons.favorite,
                    iconUntoggled: Icons.favorite_border,
                    count: tweetModel.likeCount,
                    isToggled: false,
                    onPressed: () {
                      // Like the tweet.
                      like_tweet(tweetModel.id, widget.connection).then((value) async {
                        widget._handler.handle(value);
                        // Like succeeded, we can update the tweet.
                        final result = widget._handler
                            .handle(await getTweetFromId(tweetModel.id)); // Fetching the tweet data from the server.
                        if (result != null) {
                          setState(() {
                            // Updating tweet data on the interface.
                            tweetModel = result;
                          });
                        }

                        ;
                      });
                      print("Like");
                    }),
                IconCountButton(
                    iconToggled: Icons.mode_comment,
                    iconUntoggled: Icons.mode_comment_outlined,
                    count: tweetModel.numberOfResponse,
                    isToggled: true,
                    onPressed: () {
                      // TODO : Show responses screen.
                      // Then rebuild tweet.
                    }),
                IconCountButton(
                    iconToggled: FontAwesomeIcons.retweet,
                    iconUntoggled: FontAwesomeIcons.retweet,
                    count: null,
                    isToggled: false,
                    onPressed: () {
                      // TODO : Show Retweet screen.
                    })
              ],
            ),
          ],
        ),
      ],
    );
  }
}
