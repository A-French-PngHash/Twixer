import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/search.dart';
import 'package:twixer/DataModel/search_model.dart';
import 'package:twixer/Widgets/cards/recent_search_card.dart';
import 'package:twixer/Widgets/error_handler.dart';

class RecentSearchDisplayer extends StatefulWidget {
  final Connection connection;

  /// Called when the user taps on a recent search.
  final Function(String) executeSearch;

  RecentSearchDisplayer({
    required this.connection,
    required this.executeSearch,
  });
  @override
  State<StatefulWidget> createState() {
    return _RecentSearchDisplayerState();
  }
}

class _RecentSearchDisplayerState extends State<RecentSearchDisplayer> {
  List<SearchModel> searches = [];
  ErrorHandler? _handler;

  @override
  void initState() {
    super.initState();

    getRecentSearch(widget.connection).then((result) async {
      while (_handler == null) {
        await Future.delayed(Duration(milliseconds: 50));
      }
      final res = _handler!.handle(result);
      if (res != null) {
        setState(() {
          searches = res;
          print("loaded");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _handler = ErrorHandler(context);
    final List<Widget> widgetList = [];
    for (var element in searches) {
      widgetList.add(
        Container(
          padding: EdgeInsets.all(10),
          child: RecentSearchCard(
            searchModel: element,
            onPressed: () {
              widget.executeSearch(element.content);
            },
          ),
        ),
      );
    }
    return ListView(
      scrollDirection: Axis.vertical,
      children: widgetList,
    );
  }
}
