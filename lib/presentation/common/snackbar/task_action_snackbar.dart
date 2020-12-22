import 'package:flutter/material.dart';

import 'package:clean_flutter_app/generated/l10n.dart';

void showActionMessageSnackBar(
  BuildContext context, {
  @required String message,
  bool isFailMessage = false,
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

void showFailTask(BuildContext context, {String message}) {
  showActionMessageSnackBar(context,
      message: message ?? S.current.genericFailTaskSnackBarMessage,
      isFailMessage: true);
}

void showAddTaskSuccess(BuildContext context) {
  showActionMessageSnackBar(
    context,
    message: S.current.addTaskSuccessSnackBarMessage,
  );
}

void showUpdateTaskSuccess(BuildContext context) {
  showActionMessageSnackBar(
    context,
    message: S.current.updateTaskSuccessSnackBarMessage,
  );
}

void showRemoveTaskSuccess(BuildContext context) {
  showActionMessageSnackBar(
    context,
    message: S.current.removeTaskSuccessSnackBarMessage,
  );
}
