import 'package:domain/exceptions.dart';
import 'package:flutter/material.dart';

class AsyncSnapshotResponseView<Loading, Error, Success>
    extends StatelessWidget {
  AsyncSnapshotResponseView({
    @required this.loadingWidgetBuilder,
    @required this.errorWidgetBuilder,
    @required this.successWidgetBuilder,
    @required this.snapshot,
  })  : assert(loadingWidgetBuilder != null),
        assert(errorWidgetBuilder != null),
        assert(successWidgetBuilder != null),
        assert(snapshot != null),
        assert(Loading != dynamic),
        assert(Error != dynamic),
        assert(Success != dynamic);

  final Widget Function(BuildContext context, Error loading) errorWidgetBuilder;
  final Widget Function(BuildContext context, Loading loading)
      loadingWidgetBuilder;
  final Widget Function(BuildContext context, Success loading)
      successWidgetBuilder;
  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data;

    if (data is Success) {
      return successWidgetBuilder(context, data);
    } else if (data is Error) {
      return errorWidgetBuilder(context, data);
    } else if (data is Loading || data == null) {
      return loadingWidgetBuilder(context, data);
    } else {
      throw UnknowStateException();
    }
  }
}
