import 'package:flutter/material.dart';

void showActionMessageSnackBar(
  BuildContext context, {
  @required String message,
  bool isFailMessage,
}) {
  Scaffold.of(context).removeCurrentSnackBar();

  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: isFailMessage ? Colors.red : Colors.green),
      ),
    ),
  );
}
