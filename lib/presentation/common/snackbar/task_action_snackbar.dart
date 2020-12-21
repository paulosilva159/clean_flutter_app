import 'package:flutter/material.dart';

void showActionMessageSnackBar(
  BuildContext context, {
  @required String message,
  bool hasFailed,
}) {
  Scaffold.of(context).removeCurrentSnackBar();

  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: hasFailed ? Colors.red : Colors.green),
      ),
    ),
  );
}
