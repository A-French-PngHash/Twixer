import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/request_util.dart';
import 'package:http/http.dart' as http;
import 'package:twixer/DataModel/profile_card_model.dart';

import '../DataModel/user_model.dart';
import '../DataModel/tweet_model.dart';

final requester = RequesterWithCacheInterceptor();

Future<(bool, TweetModel?, String?)> getTweetFromId(int id) async {
  final result = await requester.requestApi(
    http.get,
    "/tweet",
    {"tweet-id": id.toString()},
    cacheResponse: true,
  );
  if (result.$1) {
    return (true, TweetModel.fromJson(result.$2["tweet"]), null);
  } else {
    return (false, null, result.$2["error"] as String);
  }
}

Future<(bool, List<TweetModel>?, String?)> getTweetOnHomepage(
    {required Connection connection, required int limit, required int offset}) async {
  final result = await requester.requestApi(
    http.get,
    "/home",
    {
      "token": connection.token,
      "limit": limit.toString(),
      "offset": offset.toString(),
    },
    cacheResponse: true,
  );

  return handleListResponse(result, "tweets", TweetModel.fromJson);
}

Future<(bool, List<TweetModel>?, String?)> getTweetSearch(
    {required int limit, required int offset, required String search_string, required String order_by}) async {
  final result = await requester.requestApi(
    http.get,
    "/search",
    {
      "search-string": search_string,
      "order-by": order_by,
      "tweet-limit": limit.toString(),
      "tweet-offset": offset.toString(),
      "user-limit": "0",
      "user-offset": "0",
    },
    cacheResponse: true,
  );
  return handleListResponse(result, "tweets", TweetModel.fromJson);
}

Future<(bool, List<ProfileCardModel>?, String?)> getProfileSearch(
    {required int limit, required int offset, required String search_string}) async {
  final result = await requester.requestApi(
    http.get,
    "/search",
    {
      "search-string": search_string,
      "order-by": "date", // Value is not used for users.
      "user-limit": limit.toString(),
      "user-offset": offset.toString(),
      "tweet-limit": "0",
      "tweet-offset": "0",
    },
    cacheResponse: true,
  );
  return handleListResponse(result, "users", ProfileCardModel.fromJson);
}

Future<(bool, UserModel?, String?)> getProfileDataFor({required String username}) async {
  final result = await requester.requestApi(
    http.get,
    "/profile",
    {
      "username": username,
      "length": "0",
      "offset": "0",
      "order-by": "date",
    },
    cacheResponse: true,
  );
  if (result.$1) {
    return (true, UserModel.fromJson(result.$2 as Map<String, dynamic>), null);
  } else {
    return (false, null, result.$2["error"] as String);
  }
}

Future<(bool, List<TweetModel>?, String?)> getProfileTweets({
  required String username,
  required String orderBy,
  required int limit,
  required int offset,
}) async {
  final result = await requester.requestApi(
    http.get,
    "/profile",
    {
      "username": username,
      "length": limit.toString(),
      "offset": offset.toString(),
      "order-by": orderBy,
    },
    cacheResponse: true,
  );
  return handleListResponse(result, "tweets", TweetModel.fromJson);
}
