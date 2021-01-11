import 'package:clean_flutter_app/presentation/common/dialogs/simple_dialogs/adaptive_upsert_task_form_dialog.dart';
import 'package:domain/model/task.dart';
import 'package:flutter/material.dart';

void showAddTaskActionForm(
  BuildContext context, {
  @required void Function(Task) onUpsertTask,
  @required String formDialogTitle,
}) =>
    AdaptiveUpsertTaskFormDialog(
      formDialogTitle: formDialogTitle,
      onUpsertTask: onUpsertTask,
    ).show(context);

// TODO(paulosilva159): criar taskactionform para edit e remove
