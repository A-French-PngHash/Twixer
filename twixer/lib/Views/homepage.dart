import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/Views/write_tweet.dart';
import 'package:twixer/Widgets/buttons/new_tweet_button.dart';
import 'package:twixer/Widgets/displayers/tweet_displayer.dart';
import '../DataLogic/browsing.dart';

class Homepage extends StatelessWidget {
  final Connection connection;

  Homepage({required this.connection});

  @override
  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).colorScheme.primary);
    return Scaffold(
      appBar: AppBar(title: Text("Twixer"), scrolledUnderElevation: 0.0),
      body: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.topStart,
        children: [
          TweetDisplayer(
            get: (limit, offset) {
              return getTweetOnHomepage(connection: connection, limit: limit, offset: offset);
            },
            connection: connection,
          ),
          Positioned(
            child: NewTweetButton(onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return WriteTweet(
                      connection: this.connection,
                    );
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    final begin = Offset(0.0, 1.0);
                    final end = Offset(0.0, 0.0);
                    final position =
                        animation.drive(Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease)));
                    return SlideTransition(
                      position: position,
                      child: child,
                    );
                  },
                  transitionDuration: Duration(milliseconds: 200)));
            }),
            bottom: 20,
            right: 20,
          ),
        ],
      ),
    );
  }
}
