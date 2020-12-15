import 'package:flutter/material.dart';

import 'package:clean_flutter_app/generated/l10n.dart';

class EmptyListIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Text(S.of(context).emptyListIndicatorMessage);
}
