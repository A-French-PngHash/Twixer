import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/request_util.dart';
import 'package:http/http.dart' as http;
import 'package:twixer/config.dart';

final requester = RequesterWithCacheInterceptor();

Future<(bool, void, String?)> like_tweet(int tweet_id, Connection? connection) async {
  if (connection == null) {
    return await Future.delayed(Duration.zero, () {
      return (false, null, "You need to be logged in to like a tweet.");
    });
  }
  final result =
      await requester.request(http.post, "/like", {"token": connection.token, "tweet-id": tweet_id.toString()});
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

  final result = await requester.request(http.post, "/tweet", headers);
  if (result.$1) {
    return (true, null, null);
  } else {
    return (false, null, result.$2["error"] as String);
  }
}

Future<(bool, void, String?)> updateProfilePictureOrInfo(
  Connection connection, {
  String? bannerColor,
  String? description,
  DateTime? birthDate,
  String? name,
  Uint8List? imageBytes,
}) async {
  late (bool, Map<dynamic, dynamic>) result;
  if (imageBytes != null) {
    print("photo upload is not yet supported");
  } else {
    final Map<String, String> headers = {"token": connection.token};
    if (description != null) {
      headers["description"] = description;
    }
    if (birthDate != null) {
      headers["birth-date"] = birthDate.toIso8601String();
    }
    if (name != null) {
      headers["name"] = name;
    }
    if (bannerColor != null) {
      headers["profile-banner-color"] = bannerColor;
    }
    print(headers);
    result = await requester.request(http.post, "/profile", headers);
  }

  if (result.$1) {
    return (true, null, null);
  } else {
    return (false, null, result.$2["error"] as String);
  }
}

Future<(bool, void, String?)> retweet(Connection connection, int retweetId, String content) async {
  final headers = {
    "token": connection.token,
    "content": content,
    "tweet-id": retweetId.toString(),
  };

  final result = await requester.request(http.post, "/retweet", headers);
  if (result.$1) {
    return (true, null, null);
  } else {
    return (false, null, result.$2["error"] as String);
  }
}

Future<(bool, void, String?)> follow(Connection connection, String usernameToFollow) async {
  final result = await requester.request(http.post, "/follow", {
    "token": connection.token,
    "username-to-follow": usernameToFollow,
  });
  if (result.$1) {
    return (true, null, null);
  } else {
    return (false, null, result.$2["error"] as String);
  }
}
