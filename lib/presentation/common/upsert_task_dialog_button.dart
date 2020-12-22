import 'package:clean_flutter_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class UpsertTaskDialogButton extends StatelessWidget {
  const UpsertTaskDialogButton({
    @required this.onSaveTap,
  }) : assert(onSaveTap != null);

  final VoidCallback onSaveTap;

  @override
  Widget build(BuildContext context) => RaisedButton(
        onPressed: onSaveTap,
        child: Text(
          S.of(context).genericUpsertTaskButtonLabel,
        ),
      );
}
