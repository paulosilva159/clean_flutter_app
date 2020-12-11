import 'package:flutter/material.dart';
import 'package:clean_flutter_app/generated/l10n.dart';

class TryAgainButton extends StatelessWidget {
  const TryAgainButton({@required this.onTryAgainTap})
      : assert(onTryAgainTap != null);

  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) => RaisedButton(
        onPressed: onTryAgainTap,
        child: Text(S.of(context).tryAgainButtonLabel),
      );
}
