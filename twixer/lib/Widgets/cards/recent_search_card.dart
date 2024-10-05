import 'package:flutter/material.dart';
import 'package:twixer/DataModel/search_model.dart';

class RecentSearchCard extends StatelessWidget {
  SearchModel searchModel;
  Function onPressed;

  RecentSearchCard({required this.searchModel, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          searchModel.content,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 25),
        ),
      ),
      style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory, overlayColor: Colors.transparent),
    );
  }
}
