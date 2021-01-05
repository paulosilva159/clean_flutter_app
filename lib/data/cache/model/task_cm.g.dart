// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskCMAdapter extends TypeAdapter<TaskCM> {
  @override
  final int typeId = 0;

  @override
  TaskCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskCM(
      id: fields[0] as int,
      title: fields[2] as String,
      status: fields[3] as String,
      orientation: fields[5] as String,
      priority: fields[4] as String,
      creationTime: fields[7] as DateTime,
      deadline: fields[6] as DateTime,
      steps: (fields[8] as List)
          ?.map((dynamic e) => (e as Map)?.cast<String, dynamic>())
          ?.toList(),
      periodicity: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TaskCM obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.periodicity)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.orientation)
      ..writeByte(6)
      ..write(obj.deadline)
      ..writeByte(7)
      ..write(obj.creationTime)
      ..writeByte(8)
      ..write(obj.steps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
