import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/browsing.dart';
import 'package:twixer/DataModel/enums/order_by.dart';
import 'package:twixer/DataModel/tweet_model.dart';
import 'package:twixer/Views/searching.dart';
import 'package:twixer/Widgets/buttons/text_field_like_button.dart';
import 'package:twixer/Widgets/middle_nav_bar/middle_nav_bar.dart';
import 'package:twixer/Widgets/displayers/tweet_displayer.dart';
import 'package:twixer/Widgets/route/fadin_page_route.dart';

class SearchView extends StatefulWidget {
  final Connection connection;

  SearchView({required this.connection});

  @override
  State<StatefulWidget> createState() {
    return _SearchViewState("");
  }
}

class _SearchViewState extends State<SearchView> {
  String search_string;
  OrderBy selectedOrder = OrderBy.date;
  late Future<(bool, List<TweetModel>?, String?)> Function(int, int) get;

  _SearchViewState(this.search_string) {
    redefineGet();
  }

  void redefineGet() {
    get = (limit, offset) async {
      return await getTweetSearch(
          limit: limit,
          offset: offset,
          search_string: search_string,
          order_by: selectedOrder,
          connection: this.widget.connection);
    };
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (search_string == "") {
      widget = build_no_search(context);
    } else {
      widget = build_search(context);
    }

    return Scaffold(appBar: AppBar(title: Text("Twixer"), scrolledUnderElevation: 0.0), body: widget);
  }

  Widget build_no_search(BuildContext context) {
    return TextFieldLikeButton(search_string, true, searchFieldPressed);
  }

  Widget build_search(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFieldLikeButton(search_string, true, searchFieldPressed),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: MiddleNavBar(
                labels: OrderBy.values.map((t) => t.screenDisplay).toList(),
                onSelect: (value) {
                  setState(() {
                    this.selectedOrder = OrderBy.values[value];
                    redefineGet();
                  });
                }),
          ),
        ),
        Divider(),
        Expanded(
          child: TweetDisplayer(get: get, connection: widget.connection, key: UniqueKey()),
        ),
      ],
    );
  }

  void searchFieldPressed() {
    Navigator.of(context)
        .push(FadingPageRoute(SearchingView(
      initialSearch: search_string,
      connection: widget.connection,
    )))
        .then((value) {
      if (value != null) {
        setState(() {
          search_string = value;
        });
      }
    });
  }
}
