import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  ErrorIndicator({
    @required this.error,
    @required this.onTryAgainTap,
  });

  final dynamic error;
  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Error'),
        RaisedButton(
          onPressed: onTryAgainTap,
          child: Text('Tente Novamente'),
        ),
      ],
    );
  }
}
