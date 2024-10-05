import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:twixer/config.dart';

Future<(bool, Map)> requestApi(
  Future<Response> Function(Uri, {Map<String, String>? headers}) method,
  String subroute,
  Map<String, String> headers,
) async {
  try {
    final response = await method(
      Uri.parse(
        "$API_ROUTE$subroute",
      ),
      headers: headers,
    ).timeout(Duration(seconds: 3));
    print("$API_ROUTE$subroute");

    if (response.statusCode == 200) {
      if (response.contentLength == 0) {
        return (true, {});
      } else {
        final Map parsed = json.decode(response.body);
        return (true, parsed);
      }
    } else {
      final Map parsed = json.decode(response.body);
      return (false, parsed);
    }
  } on TimeoutException {
    return (
      false,
      {"error": "Request to : $subroute. Timeout error. Verify your connection"}
    );
  } on Exception catch (e) {
    return (false, {"error": "Request to : $subroute. ${e.toString()}"});
  }
}

/// When calling the requstApi method and receiving a list of tweet, the response is always
/// handled the sameway.
/// - String key : The key under which the data is stored in the result.
(bool, List<T>?, String?) handleListResponse<T>(
    (bool, Map<dynamic, dynamic>) result,
    String key,
    T Function(Map<String, dynamic>) fromJson) {
  if (result.$1) {
    // Request success
    final List<T> output = [];
    for (final element in result.$2[key] as List) {
      output.add(fromJson(element));
    }
    return (true, output, null);
  } else {
    return (false, null, result.$2["error"] as String);
  }
}
