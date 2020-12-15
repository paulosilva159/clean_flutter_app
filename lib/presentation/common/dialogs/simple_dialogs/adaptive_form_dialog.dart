import 'dart:io';
import 'dart:math';

import 'package:domain/model/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFormDialog extends StatefulWidget {
  const AdaptiveFormDialog({
    @required this.formDialogTitle,
    @required this.formDialogMessage,
    @required this.onUpsertTask,
    @required this.child,
    this.taskItemId,
  })  : assert(formDialogTitle != null),
        assert(formDialogMessage != null),
        assert(onUpsertTask != null),
        assert(child != null);

  final String formDialogTitle;
  final String formDialogMessage;
  final Function(Task) onUpsertTask;
  final int taskItemId;
  final Widget child;

  Future<bool> show(BuildContext context) async => Platform.isIOS
      ? showCupertinoDialog(context: context, builder: (context) => this)
      : showDialog(context: context, builder: (context) => this);

  @override
  _AdaptiveFormDialogState createState() => _AdaptiveFormDialogState();
}

class _AdaptiveFormDialogState extends State<AdaptiveFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleFieldTextEditingController = TextEditingController();

  @override
  void dispose() {
    _titleFieldTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? const CupertinoPopupSurface()
      : SimpleDialog(
          title: Text(widget.formDialogTitle),
          children: [
            Form(
              key: _formKey,
              child: TaskFormDialogFields(
                titleFieldTextEditingController:
                    _titleFieldTextEditingController,
              ),
            ),
            SaveFormButton(
              onSaveTap: () {
                _formKey.currentState.save();

                widget.onUpsertTask(
                  Task(
                    title: _titleFieldTextEditingController.value.text,
                    id: widget.taskItemId ?? Random().nextInt(99999),
                  ),
                );
              },
            ),
          ],
        );
}

class TaskFormDialogFields extends StatelessWidget {
  const TaskFormDialogFields({
    @required this.titleFieldTextEditingController,
  }) : assert(titleFieldTextEditingController != null);

  final TextEditingController titleFieldTextEditingController;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          TextFormField(
            initialValue: 'Tarefa',
            onSaved: (text) {
              titleFieldTextEditingController.text = text;
            },
          ),
        ],
      );
}

class SaveFormButton extends StatelessWidget {
  const SaveFormButton({
    @required this.onSaveTap,
  }) : assert(onSaveTap != null);

  final VoidCallback onSaveTap;

  @override
  Widget build(BuildContext context) => RaisedButton(
        onPressed: onSaveTap,
        child: const Text('save'),
      );
}
