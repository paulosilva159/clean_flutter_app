import 'dart:io';

import 'package:clean_flutter_app/presentation/common/upsert_task_dialog_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFormDialog extends StatelessWidget {
  AdaptiveFormDialog({
    @required this.formDialogTitle,
    @required this.onSaveFieldFunction,
    @required this.onTextEditingControllerDispose,
    @required this.formFields,
  })  : assert(formDialogTitle != null),
        assert(onSaveFieldFunction != null),
        assert(onTextEditingControllerDispose != null),
        assert(formFields != null);

  final String formDialogTitle;
  final VoidCallback onSaveFieldFunction;
  final VoidCallback onTextEditingControllerDispose;
  final List<FormField> formFields;

  Future<bool> show(BuildContext context) async => Platform.isIOS
      ? showCupertinoDialog(context: context, builder: (context) => this)
      : showDialog(context: context, builder: (context) => this);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? _CupertinoFormDialog(
          formDialogTitle: formDialogTitle,
          onSaveFieldFunction: onSaveFieldFunction,
          onTextEditingControllerDispose: onTextEditingControllerDispose,
          formFields: formFields,
          formKey: _formKey,
        )
      : _MaterialFormDialog(
          formDialogTitle: formDialogTitle,
          onSaveFieldFunction: onSaveFieldFunction,
          onTextEditingControllerDispose: onTextEditingControllerDispose,
          formFields: formFields,
          formKey: _formKey,
        );
}

class _MaterialFormDialog extends StatelessWidget {
  const _MaterialFormDialog({
    @required this.formDialogTitle,
    @required this.onSaveFieldFunction,
    @required this.onTextEditingControllerDispose,
    @required this.formFields,
    @required this.formKey,
  })  : assert(formDialogTitle != null),
        assert(onSaveFieldFunction != null),
        assert(onTextEditingControllerDispose != null),
        assert(formFields != null),
        assert(formKey != null);

  final GlobalKey<FormState> formKey;
  final String formDialogTitle;
  final VoidCallback onSaveFieldFunction;
  final VoidCallback onTextEditingControllerDispose;
  final List<FormField> formFields;

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text(formDialogTitle),
        children: [
          Form(
            key: formKey,
            child: Column(
              children: formFields,
            ),
          ),
          UpsertTaskDialogButton(
            onSaveTap: () async {
              formKey.currentState.save();

              onSaveFieldFunction();

              await Future.delayed(
                const Duration(milliseconds: 275),
                Navigator.of(context).pop,
              );
            },
          ),
        ],
      );
}

class _CupertinoFormDialog extends StatelessWidget {
  const _CupertinoFormDialog({
    @required this.formDialogTitle,
    @required this.onSaveFieldFunction,
    @required this.onTextEditingControllerDispose,
    @required this.formFields,
    @required this.formKey,
  })  : assert(formDialogTitle != null),
        assert(onSaveFieldFunction != null),
        assert(onTextEditingControllerDispose != null),
        assert(formFields != null),
        assert(formKey != null);

  final GlobalKey<FormState> formKey;
  final String formDialogTitle;
  final VoidCallback onSaveFieldFunction;
  final VoidCallback onTextEditingControllerDispose;
  final List<FormField> formFields;

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
                      formKey.currentState.save();

                      onSaveFieldFunction();

                      await Future.delayed(
                        const Duration(milliseconds: 275),
                        Navigator.of(context).pop,
                      );
                    },
                  ),
                ],
              )),
            ),
          ],
        ),
      );
}
