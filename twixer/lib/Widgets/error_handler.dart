import 'package:flutter/material.dart';

/// Api call responses are intended to pass through an instance of this class which
/// will take appropriate action if an error occured.
/// If the call was succesfull, returns the content of the response, otherwise displays
/// an error message to the user through a snackbar.
class ErrorHandler {
  BuildContext context;
  ErrorHandler(this.context);

  T? handle<T>((bool, T?, String?) result) {
    if (result.$1) {
      // Call succeeded.
      return result.$2;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error while loading : \n ${result.$3!}"),
      ));
      return null;
    }
  }
}
