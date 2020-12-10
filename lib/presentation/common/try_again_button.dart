import 'package:flutter/material.dart';

class TryAgainButton extends StatelessWidget {
  const TryAgainButton({@required this.onTryAgainTap})
      : assert(onTryAgainTap != null);

  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) => RaisedButton(
        onPressed: onTryAgainTap,
        child: const Text('Tente Novamente'),
      );
}
