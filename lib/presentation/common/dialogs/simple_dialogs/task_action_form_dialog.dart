import 'dart:math';

import 'package:domain/data_repository/task_repository.dart';
import 'package:flutter/material.dart';

import 'package:domain/model/task.dart';

import 'package:clean_flutter_app/presentation/common/dialogs/simple_dialogs/adaptive_form_dialog.dart';

void showUpsertTaskFormDialog(
  BuildContext context, {
  @required void Function(Task) onUpsertTask,
  @required String formDialogTitle,
  Task upsertingTask,
}) {
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
          id: upsertingTask?.id ?? Random().nextInt(99999),
          orientation: TaskListOrientation.vertical,
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
