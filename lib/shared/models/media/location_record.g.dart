// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationRecordAdapter extends TypeAdapter<LocationRecord> {
  @override
  final int typeId = 11;

  @override
  LocationRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationRecord(
      id: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      accuracy: fields[3] as double,
      altitude: fields[4] as double?,
      heading: fields[5] as double?,
      speed: fields[6] as double?,
      timestamp: fields[7] as DateTime,
      address: fields[8] as String?,
      associatedRecordId: fields[9] as String?,
      associatedRecordType: fields[10] as String?,
      isSynced: fields[11] as bool,
      metadata: (fields[12] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, LocationRecord obj) {
    writer
      ..writeByte(13)
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
      ..write(obj.heading)
      ..writeByte(6)
      ..write(obj.speed)
      ..writeByte(7)
      ..write(obj.timestamp)
      ..writeByte(8)
      ..write(obj.address)
      ..writeByte(9)
      ..write(obj.associatedRecordId)
      ..writeByte(10)
      ..write(obj.associatedRecordType)
      ..writeByte(11)
      ..write(obj.isSynced)
      ..writeByte(12)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
