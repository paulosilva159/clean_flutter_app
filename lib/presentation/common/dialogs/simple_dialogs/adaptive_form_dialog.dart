import 'dart:io';
import 'dart:math';

import 'package:domain/model/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdaptiveFormDialog extends StatefulWidget {
  const AdaptiveFormDialog({
    @required this.onUpsertTask,
    @required this.formDialogTitle,
    @required this.child,
    this.updatingTask,
  })  : assert(onUpsertTask != null),
        assert(formDialogTitle != null),
        assert(child != null);

  final void Function(Task) onUpsertTask;
  final String formDialogTitle;
  final Task updatingTask;
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
                initialValue: widget.updatingTask?.title,
              ),
            ),
            SaveFormButton(
              onSaveTap: () async {
                _formKey.currentState.save();

                widget.onUpsertTask(
                  Task(
                    title: _titleFieldTextEditingController.value.text,
                    id: widget.updatingTask?.id ?? Random().nextInt(99999),
                  ),
                );

                await Future.delayed(
                  const Duration(milliseconds: 375),
                  Navigator.of(context).pop,
                );
              },
            ),
          ],
        );
}

class TaskFormDialogFields extends StatelessWidget {
  const TaskFormDialogFields({
    @required this.titleFieldTextEditingController,
    this.initialValue = '',
  }) : assert(titleFieldTextEditingController != null);

  final TextEditingController titleFieldTextEditingController;
  final String initialValue;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          TextFormField(
            initialValue: initialValue,
            keyboardType: TextInputType.text,
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
