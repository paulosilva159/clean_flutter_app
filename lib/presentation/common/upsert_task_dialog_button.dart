import 'package:flutter/material.dart';

class UpsertTaskDialogButton extends StatelessWidget {
  const UpsertTaskDialogButton({
    @required this.onSaveTap,
  }) : assert(onSaveTap != null);

  final VoidCallback onSaveTap;

  @override
  Widget build(BuildContext context) => RaisedButton(
        onPressed: onSaveTap,
        child: const Text('save'),
      );
}
