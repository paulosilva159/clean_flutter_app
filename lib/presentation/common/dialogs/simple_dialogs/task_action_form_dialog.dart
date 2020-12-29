import 'package:clean_flutter_app/presentation/common/dialogs/simple_dialogs/adaptive_form_dialog.dart';
import 'package:domain/data_repository/task_repository.dart';
import 'package:domain/model/task.dart';
import 'package:flutter/material.dart';

void showUpsertTaskFormDialog(
  BuildContext context, {
  @required void Function(Task) onUpsertTask,
  @required String formDialogTitle,
  Task upsertingTask,
  int upsertingTaskId,
  TaskListOrientation upsertingTaskOrientation,
}) {
  assert(upsertingTask != null || upsertingTaskId != null);
  assert(upsertingTask != null || upsertingTaskOrientation != null);

  final _titleFieldTextEditingController = TextEditingController();

  AdaptiveFormDialog(
    formDialogTitle: formDialogTitle,
    onTextEdittingControllerDispose: () {
      _titleFieldTextEditingController.dispose();
    },
    onSavedFieldFunctions: () {
      onUpsertTask(
        Task(
          title: _titleFieldTextEditingController.value.text,
          id: upsertingTask?.id ?? upsertingTaskId,
          orientation: upsertingTask?.orientation ?? upsertingTaskOrientation,
        ),
      );

      _titleFieldTextEditingController.clear();
    },
    formFields: [
      TextFormField(
        initialValue: upsertingTask?.title ?? '',
        keyboardType: TextInputType.text,
        onSaved: (text) {
          _titleFieldTextEditingController.text = text;
        },
      )
    ],
  ).show(context);
}
