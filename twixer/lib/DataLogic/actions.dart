import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/request_util.dart';
import 'package:http/http.dart' as http;

final requester = RequesterWithCacheInterceptor();

Future<(bool, void, String?)> like_tweet(int tweet_id, Connection? connection) async {
  if (connection == null) {
    return await Future.delayed(Duration.zero, () {
      return (false, null, "You need to be logged in to like a tweet.");
    });
  }
  final result =
      await requester.requestApi(http.post, "/like", {"token": connection.token, "tweet-id": tweet_id.toString()});
  if (result.$1) {
    return (true, null, null);
  } else {
    return (false, null, result.$2["error"] as String);
  }
}

Future<(bool, void, String?)> postTweet(Connection connection, String content, int? repliesTo) async {
  final headers = {
    "token": connection.token,
    "content": content,
    "replies-to": repliesTo == null ? "-1" : repliesTo.toString(),
  };

  final result = await requester.requestApi(http.post, "/tweet", headers);
  if (result.$1) {
    return (true, null, null);
  } else {
    return (false, null, result.$2["error"] as String);
  }
}
