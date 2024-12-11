import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:twixer/config.dart';

/// Interceptor that sits between the server and the user.
///
/// If a query is executed that has already been executed and the cached
/// response is not expired then the Interceptor does not do a network call but
/// rather gets the response from its internal cache.
///
/// Implements:
///   - `request`
///   - `requestNoParsing`
///   - `requestParsingNoCache`
///   - `nameFromMethod`
///
class RequesterWithCacheInterceptor {
  // Singleton :
  static final RequesterWithCacheInterceptor _requester = RequesterWithCacheInterceptor._internal();
  factory RequesterWithCacheInterceptor() {
    return _requester;
  }
  RequesterWithCacheInterceptor._internal() {}

  /// Stores requests and their responses.
  ///
  /// Key :
  ///   - Function : The function used to query (http.get, http.post..)
  ///   - String : The subroute queried.
  ///   - Map<String, String> : The headers of the request.
  ///
  /// Value :
  ///   - Map : The parsed response.
  final Map<String, Map> _cache = {};

  /// Same as the cache but for raw request (see available methods).
  final Map<String, Map> _rawCache = {};

  /// Execute a request if the reponse is not already in cache and then stores
  /// the response in cache according to the specified parameters.
  ///
  /// When using this function, the reponse is not raw, it is processed :
  /// the first parameter returned is whether the call was successful or not.
  /// The second parameter is the parsed response.
  ///
  /// To send raw request (with caching enabled) without parsing, use `requestApiNoParsing`.
  Future<(bool, Map)> request(
    Future<Response> Function(Uri, {Map<String, String>? headers}) method,
    String subroute,
    Map<String, String> headers, {
    bool cacheResponse = false,
    int expirationDuration = 0,
  }) async {
    final name = nameFromMethod(method);

    final key = name + subroute + headers.toString();
    if (method != post && _cache.containsKey(key)) {
      final cached = _cache[key]!;
      if (DateTime.now().millisecondsSinceEpoch < (int.parse(cached["expires"]))) {
        return cached["response"];
      }
    }

    final response = await requestParsingNoCache(
        send: () async {
          return await method(
            Uri.parse(
              "$API_ROUTE$subroute",
            ),
            headers: headers,
          );
        },
        subroute: subroute);
    if (cacheResponse) {
      _cache[key] = {
        "expires": (DateTime.now().millisecondsSinceEpoch + 1000 * expirationDuration).toString(),
        "response": response
      };
    }
    return response;
  }

  /// Executes the `method` function with the given parameters.
  ///
  /// The difference with `requestApi` is that this function does not parse the
  /// response and returns the raw response.
  /// WARNING: This request consults the cache to see if the response to your
  /// request is already there.
  Future<Response> requestNoParsing(
    Future<Response> Function(Uri, {Map<String, String>? headers}) method,
    String subroute,
    Map<String, String> headers, {
    bool cacheResponse = false,
    int expirationDuration = 60,
  }) async {
    final name = nameFromMethod(method);
    final key = name + subroute + headers.toString();
    if (_rawCache.containsKey(key)) {
      final cached = _rawCache[key]!;
      if (DateTime.now().millisecondsSinceEpoch < (int.parse(cached["expires"]))) {
        return cached["response"];
      }
    }
    final response = await method(
      Uri.parse(
        "$API_ROUTE$subroute",
      ),
      headers: headers,
    );
    if (cacheResponse) {
      _rawCache[key] = {
        "expires": (DateTime.now().millisecondsSinceEpoch + 1000 * expirationDuration).toString(),
        "response": response
      };
    }
    return response;
  }

  /// Executes send() with timeout protection and response parsing.
  ///
  /// This function should be used when you have a very specific request to
  /// build (if the request can be built using headers and a URI then use
  /// `requestApi` or `requestApiNoParsing`). You build the request and then
  /// give it to this function. The function executes it, add timeout protection
  ///  and parses the response.
  ///
  /// The subroute parameter is given only for debuging purposes.
  Future<(bool, Map)> requestParsingNoCache(
      {required Future<Response> Function() send, required String subroute}) async {
    try {
      final Response response = await send().timeout(Duration(seconds: 3));
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
      return (false, {"error": "Request to : $subroute. Timeout error. Verify your connection"});
    } on Exception catch (e) {
      print(e);
      print("ERROR NOW");
      return (false, {"error": "Request to : $subroute. ${e.toString()}"});
    }
  }

  String nameFromMethod(method) {
    switch (method) {
      case get:
        return "get";
      case post:
        return "post";

      default:
        throw Exception("Unknown method");
    }
  }
}

/// When calling the requstApi method and receiving a list of tweet, the response is always
/// handled the sameway.
/// - String key : The key under which the data is stored in the result.
(bool, List<T>?, String?) handleListResponse<T>(
    (bool, Map<dynamic, dynamic>) result, String key, T Function(Map<String, dynamic>) fromJson) {
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
