import 'package:flutter/material.dart';

import 'package:clean_flutter_app/common/try_again_button.dart';

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
          TryAgainButton(onTryAgainTap: onTryAgainTap),
        ],
      );
}
