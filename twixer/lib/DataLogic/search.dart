import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/request_util.dart';
import 'package:twixer/DataModel/search_model.dart';
import 'package:http/http.dart' as http;

Future<(bool, List<SearchModel>?, String?)> getRecentSearch(
    Connection connection) async {
  final result = await requestApi(
      http.get, "/search/history", {"token": connection.token});
  print(result.$2);

  return handleListResponse(result, "searches", SearchModel.fromJson);
}

Future<(bool, void, String?)> postSearch(
    Connection connection, String content) async {
  final result = await requestApi(http.post, "/search/history",
      {"token": connection.token, "content": content});
  if (result.$1) {
    return (true, null, null);
  } else {
    print(result.$2["error"] as String);
    return (false, null, result.$2["error"] as String);
  }
}
