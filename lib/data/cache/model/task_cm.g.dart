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
      title: fields[1] as String,
      id: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TaskCM obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title);
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
