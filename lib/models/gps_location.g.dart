// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GpsLocationAdapter extends TypeAdapter<GpsLocation> {
  @override
  final int typeId = 4;

  @override
  GpsLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GpsLocation(
      id: fields[0] as String?,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      accuracy: fields[3] as double?,
      altitude: fields[4] as double?,
      speed: fields[5] as double?,
      timestamp: fields[6] as DateTime,
      providerType: fields[7] as String,
      address: fields[8] as String?,
      isMocked: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GpsLocation obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.accuracy)
      ..writeByte(4)
      ..write(obj.altitude)
      ..writeByte(5)
      ..write(obj.speed)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.providerType)
      ..writeByte(8)
      ..write(obj.address)
      ..writeByte(9)
      ..write(obj.isMocked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GpsLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
