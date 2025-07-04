// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shot.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShotAdapter extends TypeAdapter<Shot> {
  @override
  final int typeId = 2;

  @override
  Shot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Shot(
      id: fields[0] as String,
      clubId: fields[1] as String,
      distance: fields[2] as double,
      timestamp: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Shot obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.clubId)
      ..writeByte(2)
      ..write(obj.distance)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
