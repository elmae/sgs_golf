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

class GolfClubTypeAdapter extends TypeAdapter<GolfClubType> {
  @override
  final int typeId = 10;

  @override
  GolfClubType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GolfClubType.pw;
      case 1:
        return GolfClubType.gw;
      case 2:
        return GolfClubType.sw;
      case 3:
        return GolfClubType.lw;
      default:
        return GolfClubType.pw;
    }
  }

  @override
  void write(BinaryWriter writer, GolfClubType obj) {
    switch (obj) {
      case GolfClubType.pw:
        writer.writeByte(0);
        break;
      case GolfClubType.gw:
        writer.writeByte(1);
        break;
      case GolfClubType.sw:
        writer.writeByte(2);
        break;
      case GolfClubType.lw:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GolfClubTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
