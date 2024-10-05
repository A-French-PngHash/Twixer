import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/auth.dart';
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: TweetDisplayer(
          get: (limit, offset) {
            return getTweetOnHomepage(connection: connection, limit: limit, offset: offset);
          },
          connection: connection,
        ),
      ),
    );
  }
}
