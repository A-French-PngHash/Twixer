import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:twixer/DataLogic/request_util.dart';

final requester = RequesterWithCacheInterceptor();

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

class Connection {
  /// An instance of this object is passed to the datalogic functions when making calls to api.
  String token;
  bool isGuest;
  int user_id;
  String? username;

  Connection(this.token, this.isGuest, this.user_id, {this.username});

  /// Logs the user in using the provided credentials.
  /// The bool returned indicates whether the request was sucessful in which case a Connection instance is passed.
  /// Otherwise, an error message is given for it to be displayed to the user.
  static Future<(bool, Connection?, String?)> establishLogin(String username, String password) async {
    return await _util(username.toLowerCase(), password, http.get, "/login");
  }

  static createAccount(String username, String password) async {
    return await _util(username.toLowerCase(), password, http.post, "/signup");
  }

  static Future<(bool, Connection?, String?)> _util(String username, String password, method, route) async {
    final lowerusername = username.toLowerCase();
    final digest = _computeDigest(password, lowerusername);
    final result =
        await requester.request(method, route, {"username": lowerusername, "digest": digest, "name": username});
    if (result.$1) {
      return (true, Connection(result.$2["token"], false, result.$2["user-id"], username: lowerusername), null);
    } else {
      return (false, null, result.$2["error"] as String);
    }
  }

  static String _computeDigest(String password, String username) {
    return md5.convert(utf8.encode("$username:$password")).toString();
  }
}
