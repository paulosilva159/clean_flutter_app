import 'package:clean_flutter_app/generated/l10n.dart';
import 'package:flutter/material.dart';

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
      message: message ?? S.of(context).genericFailTaskSnackBarMessage,
      isFailMessage: true);
}

void showAddTaskSuccess(BuildContext context) {
  showActionMessageSnackBar(
    context,
    message: S.of(context).addTaskSuccessSnackBarMessage,
  );
}

void showUpdateTaskSuccess(BuildContext context) {
  showActionMessageSnackBar(
    context,
    message: S.of(context).updateTaskSuccessSnackBarMessage,
  );
}

void showRemoveTaskSuccess(BuildContext context) {
  showActionMessageSnackBar(
    context,
    message: S.of(context).removeTaskSuccessSnackBarMessage,
  );
}

void showReorderTaskSuccess(BuildContext context) {
  showActionMessageSnackBar(
    context,
    message: S.of(context).reorderTasksSuccessSnackBarMessage,
  );
}
