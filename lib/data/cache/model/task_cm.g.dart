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
      title: fields[5] as String,
      status: fields[6] as String,
      orientation: fields[7] as String,
      days: fields[1] as int,
      steps: (fields[2] as List)
          ?.map((dynamic e) => (e as Map)?.cast<String, dynamic>())
          ?.toList(),
      periodicity: fields[3] as int,
      progress: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TaskCM obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.days)
      ..writeByte(2)
      ..write(obj.steps)
      ..writeByte(3)
      ..write(obj.periodicity)
      ..writeByte(4)
      ..write(obj.progress)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.orientation);
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
