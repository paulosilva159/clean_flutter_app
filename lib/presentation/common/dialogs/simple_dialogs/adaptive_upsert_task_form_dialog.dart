import 'dart:io';

import 'package:clean_flutter_app/common/uuid_generator.dart';
import 'package:clean_flutter_app/presentation/common/buttons/upsert_task_dialog_button.dart';
import 'package:domain/common/task_list_orientation.dart';
import 'package:domain/common/task_priority.dart';
import 'package:domain/model/task.dart';
import 'package:domain/model/task_step.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO(paulosilva159): checar strings hardcoded e trocar por S

final uuidGenerator = UUIDGenerator.version4();

class AdaptiveUpsertTaskFormDialog extends StatefulWidget {
  const AdaptiveUpsertTaskFormDialog({
    @required this.formDialogTitle,
    @required this.onUpsertTask,
  })  : assert(formDialogTitle != null),
        assert(onUpsertTask != null);

  final String formDialogTitle;
  final void Function(Task) onUpsertTask;

  Future<bool> show(BuildContext context) async => Platform.isIOS
      ? showCupertinoDialog(context: context, builder: (context) => this)
      : showDialog(context: context, builder: (context) => this);

  @override
  _AdaptiveUpsertTaskFormDialogState createState() =>
      _AdaptiveUpsertTaskFormDialogState();
}

class _AdaptiveUpsertTaskFormDialogState
    extends State<AdaptiveUpsertTaskFormDialog> {
  final _taskStepList = <TaskStep>[];
  DateTime _selectedDeadline;
  FocusNode _titleFieldFocusNode;
  FocusNode _taskPriorityDropdownFocusNode;
  FocusNode _taskListOrientationDropdownFocusNode;
  TaskPriority _selectedTaskPriority;
  TaskListOrientation _selectedTaskListOrientation;
  GlobalKey<FormState> _formKey;
  TextEditingController _titleFieldTextEditingController;

  void onDispose() {
    _titleFieldFocusNode.dispose();
    _taskPriorityDropdownFocusNode.dispose();
    _taskListOrientationDropdownFocusNode.dispose();

    _titleFieldTextEditingController.dispose();
  }

  void _onComplete() => widget.onUpsertTask(
        Task(
          id: uuidGenerator.uuid,
          title: _titleFieldTextEditingController.value.text,
          orientation: _selectedTaskListOrientation,
          creationTime: DateTime.now(),
          deadline: _selectedDeadline,
          steps: _taskStepList,
          priority: _selectedTaskPriority,
        ),
      );

  void _onAddTaskStep(TaskStep step) {
    setState(() {
      _taskStepList.add(step);
    });
  }

  List<FormField> _formFields() => [
        DropdownButtonFormField<TaskListOrientation>(
          hint: const Text('orientation'),
          autofocus: true,
          focusNode: _taskListOrientationDropdownFocusNode,
          items: TaskListOrientation.values
              .map(
                (orientation) => DropdownMenuItem<TaskListOrientation>(
                  value: orientation,
                  child: Text(
                    EnumToString.convertToString(orientation),
                  ),
                ),
              )
              .toList(),
          value: _selectedTaskListOrientation,
          onChanged: (orientation) {
            _selectedTaskListOrientation = orientation;
            _taskListOrientationDropdownFocusNode.nextFocus();
          },
        ),
        TextFormField(
          focusNode: _titleFieldFocusNode,
          controller: _titleFieldTextEditingController,
          textInputAction: TextInputAction.next,
          onEditingComplete: _titleFieldFocusNode.nextFocus,
          keyboardType: TextInputType.text,
          onSaved: (text) {
            _titleFieldTextEditingController.text = text;
          },
        ),
        DropdownButtonFormField<TaskPriority>(
          focusNode: _taskPriorityDropdownFocusNode,
          items: TaskPriority.values
              .map(
                (priority) => DropdownMenuItem<TaskPriority>(
                  value: priority,
                  child: Text(
                    EnumToString.convertToString(priority),
                  ),
                ),
              )
              .toList(),
          value: _selectedTaskPriority,
          onChanged: (priority) {
            _selectedTaskPriority = priority;

            _taskPriorityDropdownFocusNode.unfocus();
          },
        ),
        _DeadlinePickerFormField(
          deadline: _selectedDeadline,
          onPickDeadline: (deadline) {
            setState(() {
              _selectedDeadline = deadline;
            });

            print(_selectedDeadline);
          },
        ).build(context),
        _TaskStepFormField(
          isHorizontalTaskList:
              _selectedTaskListOrientation == TaskListOrientation.horizontal,
          onAddTaskStep: _onAddTaskStep,
          taskSteps: _taskStepList,
        ).build(context),
      ];

  @override
  void initState() {
    _titleFieldFocusNode = FocusNode();
    _taskPriorityDropdownFocusNode = FocusNode();
    _taskListOrientationDropdownFocusNode = FocusNode();

    _titleFieldTextEditingController = TextEditingController();

    _formKey = GlobalKey<FormState>();

    super.initState();
  }

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? _CupertinoUpsertTaskFormDialog(
          onCompleteForm: _onComplete,
          formDialogTitle: widget.formDialogTitle,
          formFields: _formFields(),
          formKey: _formKey,
        )
      : _MaterialUpsertTaskFormDialog(
          onCompleteForm: _onComplete,
          formDialogTitle: widget.formDialogTitle,
          formFields: _formFields(),
          formKey: _formKey,
        );
}

class _MaterialUpsertTaskFormDialog extends StatelessWidget {
  const _MaterialUpsertTaskFormDialog({
    @required this.formDialogTitle,
    @required this.formFields,
    @required this.formKey,
    @required this.onCompleteForm,
  })  : assert(formDialogTitle != null),
        assert(formFields != null),
        assert(onCompleteForm != null),
        assert(formKey != null);

  final GlobalKey<FormState> formKey;
  final String formDialogTitle;
  final List<FormField> formFields;
  final VoidCallback onCompleteForm;

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text(formDialogTitle),
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                ...formFields,
              ],
            ),
          ),
          UpsertTaskDialogButton(
            onSaveTap: () async {
              onCompleteForm();

              formKey.currentState
                ..save()
                ..reset();

              await _onCloseDialog(context);
            },
          ),
        ],
      );
}

class _CupertinoUpsertTaskFormDialog extends StatelessWidget {
  const _CupertinoUpsertTaskFormDialog({
    @required this.formDialogTitle,
    @required this.formFields,
    @required this.formKey,
    @required this.onCompleteForm,
  })  : assert(formDialogTitle != null),
        assert(formFields != null),
        assert(onCompleteForm != null),
        assert(formKey != null);

  final GlobalKey<FormState> formKey;
  final String formDialogTitle;
  final List<FormField> formFields;
  final VoidCallback onCompleteForm;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(50),
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoPopupSurface(
              isSurfacePainted: false,
              child: Material(
                child: Column(
                  children: [
                    Text(formDialogTitle),
                    Form(
                      key: formKey,
                      child: Column(
                        children: formFields,
                      ),
                    ),
                    UpsertTaskDialogButton(
                      onSaveTap: () async {
                        onCompleteForm();

                        formKey.currentState
                          ..save()
                          ..reset();

                        await _onCloseDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _DeadlinePickerFormField extends StatelessWidget {
  const _DeadlinePickerFormField({
    @required this.onPickDeadline,
    this.deadline,
  }) : assert(onPickDeadline != null);

  final void Function(DateTime) onPickDeadline;
  final DateTime deadline;

  @override
  Widget build(BuildContext context) => FormField<DateTime>(
        builder: (_) => FlatButton.icon(
          onPressed: () async {
            final _pickedDeadline = await showDatePicker(
              context: context,
              initialDate: deadline ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.utc(DateTime.now().year + 10),
            );

            onPickDeadline(_pickedDeadline);
          },
          icon: const Icon(
            Icons.calendar_today_rounded,
          ),
          label: Text(
            deadline?.toString() ?? 'CHOOSE',
          ),
        ),
      );
}

class _TaskStepFormField extends StatelessWidget {
  const _TaskStepFormField({
    @required this.taskSteps,
    @required this.onAddTaskStep,
    @required this.isHorizontalTaskList,
  })  : assert(taskSteps != null),
        assert(onAddTaskStep != null),
        assert(isHorizontalTaskList != null);

  final List<TaskStep> taskSteps;
  final void Function(TaskStep) onAddTaskStep;
  final bool isHorizontalTaskList;

  @override
  Widget build(BuildContext context) => FormField<TaskStep>(
        builder: (_) => Visibility(
          visible: isHorizontalTaskList,
          child: Column(
            children: [
              ...taskSteps
                  .map(
                    (step) => Container(
                      child: Text(step.title),
                    ),
                  )
                  .toList(),
              FlatButton.icon(
                onPressed: () {
                  onAddTaskStep(
                    TaskStep(
                      id: uuidGenerator.uuid,
                      title: 'sexo',
                      creationTime: DateTime.now(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('adiconar step'),
              ),
            ],
          ),
        ),
      );
}

Future<void> _onCloseDialog(BuildContext context) => Future.delayed(
      const Duration(milliseconds: 275),
      Navigator.of(context).pop,
    );
