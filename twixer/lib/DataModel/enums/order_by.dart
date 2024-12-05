import 'package:flutter/material.dart';
import 'package:twixer/config.dart';

enum OrderBy {
  date,
  popularity,
  numberOfResponse;

  String get apiFormat {
    switch (this) {
      case numberOfResponse:
        return "number_of_response";
      default:
        return name;
    }
  }

  String get screenDisplay {
    switch (this) {
      case numberOfResponse:
        return "Most commented";
      case date:
        return "Latest";
      case popularity:
        return "Most liked";
    }
  }

  Icon get icon {
    switch (this) {
      case numberOfResponse:
        return Icon(
          Icons.forum_outlined,
          color: BLUE,
        );
      case date:
        return Icon(Icons.calendar_month_rounded, color: Color(0xFF8B7DBE));
      case popularity:
        return Icon(Icons.favorite, color: Colors.red);
    }
  }
}
