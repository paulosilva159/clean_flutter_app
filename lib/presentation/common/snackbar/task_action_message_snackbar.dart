import 'package:clean_flutter_app/generated/l10n.dart';
import 'package:flutter/material.dart';

void showActionMessageSnackBar(
  BuildContext context, {
  @required String message,
  bool isFailMessage = false,
}) {
  Scaffold.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isFailMessage ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
}

void showFailTask(BuildContext context, {String message}) {
  showActionMessageSnackBar(
    context,
    message: message ?? S.of(context).genericFailTaskSnackBarMessage,
    isFailMessage: true,
  );
}

void showSuccessTask(BuildContext context, {String message}) {
  showActionMessageSnackBar(
    context,
    message: message ?? S.of(context).genericSuccessTaskSnackBarMessage,
  );
}
