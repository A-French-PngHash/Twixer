import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:twixer/DataLogic/request_util.dart';

Future<(bool, Image?, String?)> getProfilePicture(String username) async {
  final response = await RequesterWithCacheInterceptor()
      .rawRequestApi(http.get, "/profile/picture", {"username": username}, cacheResponse: true, expirationDuration: 6);
  if (response.statusCode == 200) {
    if (response.contentLength == 0) {
      print("0 length");
      return (true, null, null);
    } else {
      return (
        true,
        Image.memory(
          response.bodyBytes,
          gaplessPlayback: true,
        ),
        ""
      );
    }
  } else {
    final Map parsed = json.decode(response.body);
    return (false, null, parsed["error"] as String);
  }
}
