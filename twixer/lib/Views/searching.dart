import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/browsing.dart';
import 'package:twixer/DataLogic/search.dart';
import 'package:twixer/Widgets/displayers/profile_displayer.dart';
import 'package:twixer/Widgets/displayers/recent_search_displayer.dart';
import 'package:twixer/Widgets/other/error_handler.dart';

/// View displayed when the user is typing in the search bar.
class SearchingView extends StatefulWidget {
  final String initialSearch;
  final Connection connection;

  SearchingView({required this.initialSearch, required this.connection});

  @override
  State<StatefulWidget> createState() {
    return _SearchingViewState(initialSearch);
  }
}

class _SearchingViewState extends State<SearchingView> {
  late final TextEditingController controller;
  late String searchContent;

  _SearchingViewState(initialSearch) {
    searchContent = initialSearch;
    controller = TextEditingController(text: initialSearch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildSearchBar(context),
          Divider(),
          Expanded(
            child: (searchContent == "")
                ? new RecentSearchDisplayer(
                    connection: widget.connection,
                    executeSearch: (value) {
                      doSearch(context, value);
                    })
                : ProfileDisplayer(
                    get: (limit, offset) {
                      return getProfileSearch(limit: limit, offset: offset, search_string: searchContent);
                    },
                    connection: widget.connection,
                    key: UniqueKey(),
                  ),
          )
        ],
      ),
    );
  }

  Widget buildSearchBar(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary,
            ),
            iconSize: 40,
          ),
        ),
        Expanded(
          child: TextField(
            autocorrect: false,
            controller: controller,
            onChanged: (value) {
              setState(() {
                searchContent = value;
              });
            },
            onSubmitted: (value) {
              doSearch(context, value);
            },
            decoration: InputDecoration(
                hintText: "Search here",
                border: InputBorder.none,
                labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black)),
            autofocus: true,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: IconButton(
            onPressed: () {
              controller.value = TextEditingValue.empty;
              setState(() {
                searchContent = "";
              });
            },
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.secondary,
            ),
            iconSize: 30,
          ),
        ),
      ],
    );
  }

  /// Searches are done when a value is submmitted in the search bar or when
  /// the user clicks on a recent search.
  void doSearch(BuildContext context, String value) async {
    postSearch(widget.connection, value).then(
      (response) {
        ErrorHandler(context).handle(response);
      },
    );
    Navigator.pop(context, value);
  }
}
