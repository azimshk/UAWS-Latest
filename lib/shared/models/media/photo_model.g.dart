// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhotoModelAdapter extends TypeAdapter<PhotoModel> {
  @override
  final int typeId = 10;

  @override
  PhotoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhotoModel(
      id: fields[0] as String,
      localPath: fields[1] as String,
      remotePath: fields[2] as String?,
      latitude: fields[3] as double?,
      longitude: fields[4] as double?,
      capturedAt: fields[5] as DateTime,
      fileSize: fields[6] as int,
      mimeType: fields[7] as String,
      isCompressed: fields[8] as bool,
      description: fields[9] as String?,
      associatedRecordId: fields[10] as String?,
      associatedRecordType: fields[11] as String?,
      isSynced: fields[12] as bool,
      metadata: (fields[13] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, PhotoModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.localPath)
      ..writeByte(2)
      ..write(obj.remotePath)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.capturedAt)
      ..writeByte(6)
      ..write(obj.fileSize)
      ..writeByte(7)
      ..write(obj.mimeType)
      ..writeByte(8)
      ..write(obj.isCompressed)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.associatedRecordId)
      ..writeByte(11)
      ..write(obj.associatedRecordType)
      ..writeByte(12)
      ..write(obj.isSynced)
      ..writeByte(13)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
