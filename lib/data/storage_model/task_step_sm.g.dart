// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_step_sm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskStepSM _$TaskStepSMFromJson(Map<String, dynamic> json) {
  return TaskStepSM(
    id: json['id'] as int,
    title: json['title'] as String,
    status: _$enumDecode(_$TaskStatusEnumMap, json['status']),
  );
}

Map<String, dynamic> _$TaskStepSMToJson(TaskStepSM instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': _$TaskStatusEnumMap[instance.status],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

const _$TaskStatusEnumMap = {
  TaskStatus.undone: 'undone',
  TaskStatus.done: 'done',
};
