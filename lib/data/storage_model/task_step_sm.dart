import 'package:domain/model/task_status.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'task_step_sm.g.dart';

@JsonSerializable(nullable: false)
class TaskStepSM {
  TaskStepSM({
    @required this.id,
    @required this.title,
    @required this.status,
  })  : assert(id != null),
        assert(title != null),
        assert(status != null);

  factory TaskStepSM.fromJson(Map<String, dynamic> json) =>
      _$TaskStepSMFromJson(json);

  Map<String, dynamic> toJson() => _$TaskStepSMToJson(this);

  final int id;
  final String title;
  final TaskStatus status;
}
