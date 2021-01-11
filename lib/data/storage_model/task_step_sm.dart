import 'package:domain/common/task_status.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'task_step_sm.g.dart';

@JsonSerializable(nullable: false)
class TaskStepSM {
  TaskStepSM({
    @required this.id,
    @required this.title,
    @required this.status,
    @required this.creationTime,
  })  : assert(id != null),
        assert(title != null),
        assert(status != null),
        assert(creationTime != null);

  factory TaskStepSM.fromJson(Map<String, dynamic> json) =>
      _$TaskStepSMFromJson(json);

  Map<String, dynamic> toJson() => _$TaskStepSMToJson(this);

  final String id;
  final String title;
  final TaskStatus status;
  final DateTime creationTime;
}
