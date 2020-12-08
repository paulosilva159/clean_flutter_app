import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    @required this.error,
    @required this.onTryAgainTap,
  });

  final dynamic error;
  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Text('Error'),
          RaisedButton(
            onPressed: onTryAgainTap,
            child: const Text('Tente Novamente'),
          ),
        ],
      );
}
