// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'golf_club.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GolfClubAdapter extends TypeAdapter<GolfClub> {
  @override
  final int typeId = 1;

  @override
  GolfClub read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GolfClub(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GolfClub obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GolfClubAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
