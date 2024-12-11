import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:twixer/DataLogic/request_util.dart';
import 'package:twixer/config.dart';

class ProfilePictureService {
  // Singleton
  static final ProfilePictureService _service = ProfilePictureService._internal();
  factory ProfilePictureService() {
    return _service;
  }
  ProfilePictureService._internal() {}

  /// Dictionary associating a username with :
  ///   - a profile picture
  ///   - an expiration date
  final Map<String, (DateTime, Image)> fetched = {};

  final List<(String, void Function((bool, Image?, String?)))> queue = [];

  void getProfilePicture(String username, void Function((bool, Image?, String?)) callback) async {
    if (queue.isEmpty) {
      // Add to queue and start fetching from this function.
      queue.add((username, callback));
      while (queue.isNotEmpty) {
        await this._completeQueueElement(queue[0]);
        queue.removeAt(0);
      }
    } else {
      // Add to queue and will be automaticlaly executed when the queue is being completed.
      queue.add((username, callback));
    }
  }

  Future<void> _completeQueueElement((String, void Function((bool, Image?, String?))) element) async {
    final callback = element.$2;

    if (fetched.containsKey(element.$1) && fetched[element.$1]!.$1.isAfter(DateTime.now())) {
      callback((true, fetched[element.$1]!.$2, null));
      return;
    }

    final response = await http.get(
      Uri.parse("$API_ROUTE/profile/picture"),
      headers: {"username": element.$1},
    
    );
    if (response.statusCode == 200) {
      if (response.contentLength == 0) {
        callback((true, null, null));
      } else {
        final image = Image.memory(
          response.bodyBytes,
          gaplessPlayback: true,
        );
        fetched[element.$1] = (DateTime.now().add(Duration(seconds: 10)), image);
        callback((true, image, null));
      }
    } else {
      final Map parsed = json.decode(response.body);
      callback((false, null, parsed["error"] as String));
    }
  }
}
