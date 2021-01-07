import 'package:clean_flutter_app/generated/l10n.dart';
import 'package:clean_flutter_app/presentation/common/buttons/try_again_button.dart';
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
          Text(S.of(context).errorIndicatorMessage),
          TryAgainButton(onTryAgainTap: onTryAgainTap),
        ],
      );
}
