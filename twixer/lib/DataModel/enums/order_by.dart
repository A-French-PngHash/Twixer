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
}
