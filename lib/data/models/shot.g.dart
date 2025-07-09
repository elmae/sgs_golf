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
      clubType: fields[0] as GolfClubType,
      distance: fields[1] as double,
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Shot obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.clubType)
      ..writeByte(1)
      ..write(obj.distance)
      ..writeByte(2)
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
