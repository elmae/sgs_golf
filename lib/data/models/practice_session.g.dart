// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PracticeSessionAdapter extends TypeAdapter<PracticeSession> {
  @override
  final int typeId = 3;

  @override
  PracticeSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PracticeSession(
      id: fields[0] as String,
      userId: fields[1] as String,
      date: fields[2] as DateTime,
      shotIds: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PracticeSession obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.shotIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PracticeSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
