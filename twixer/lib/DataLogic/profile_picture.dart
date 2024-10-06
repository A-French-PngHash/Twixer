import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:twixer/config.dart';

Future<(bool, Image?, String?)> getProfilePicture(String username) async {
  final response = await http.get(Uri.parse("$API_ROUTE/profile/picture"),
      headers: {"username": username});
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
