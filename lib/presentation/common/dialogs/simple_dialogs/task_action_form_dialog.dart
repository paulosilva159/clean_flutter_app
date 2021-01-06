import 'package:clean_flutter_app/presentation/common/dialogs/simple_dialogs/adaptive_form_dialog.dart';
import 'package:domain/common/task_list_orientation.dart';
import 'package:domain/common/task_priority.dart';
import 'package:domain/common/task_status.dart';
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

  final _titleFieldFocusNode = FocusNode();

  final _titleFieldTextEditingController = TextEditingController();

  const _initialTaskStatus = TaskStatus.undone;

  void _onCompleteEditingTextField() {
    onUpsertTask(
      Task(
        title: _titleFieldTextEditingController.value.text,
        id: upsertingTask?.id ?? upsertingTaskId,
        orientation: upsertingTask?.orientation ?? upsertingTaskOrientation,
        status: upsertingTask?.status ?? _initialTaskStatus,
        priority: TaskPriority.normal,
        creationTime: DateTime.now(),
        deadline: DateTime.utc(2022),
      ),
    );

    _titleFieldTextEditingController.clear();
  }

  AdaptiveFormDialog(
    formDialogTitle: formDialogTitle,
    onTextEditingControllerDispose: () {
      _titleFieldTextEditingController.dispose();
      _titleFieldFocusNode.dispose();
    },
    onSaveFieldFunction: _onCompleteEditingTextField,
    formFields: [
      TextFormField(
        focusNode: _titleFieldFocusNode,
        initialValue: upsertingTask?.title ?? '',
        keyboardType: TextInputType.text,
        onSaved: (text) {
          _titleFieldTextEditingController.text = text;
        },
      )
    ],
  ).show(context);
}
