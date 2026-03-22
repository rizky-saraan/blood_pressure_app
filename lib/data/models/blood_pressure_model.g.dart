// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_pressure_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BloodPressureModelAdapter extends TypeAdapter<BloodPressureModel> {
  @override
  final int typeId = 0;

  @override
  BloodPressureModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BloodPressureModel(
      tanggal: fields[0] as String,
      jam: fields[1] as String,
      sistolik1: fields[2] as int,
      diastolik1: fields[3] as int,
      sistolik2: fields[4] as int,
      diastolik2: fields[5] as int,
      sistolik3: fields[6] as int,
      diastolik3: fields[7] as int,
      rataSistolik: fields[8] as int,
      rataDiastolik: fields[9] as int,
      nadi: fields[10] as int,
      kondisi: fields[11] as String,
      aktivitas: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BloodPressureModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.tanggal)
      ..writeByte(1)
      ..write(obj.jam)
      ..writeByte(2)
      ..write(obj.sistolik1)
      ..writeByte(3)
      ..write(obj.diastolik1)
      ..writeByte(4)
      ..write(obj.sistolik2)
      ..writeByte(5)
      ..write(obj.diastolik2)
      ..writeByte(6)
      ..write(obj.sistolik3)
      ..writeByte(7)
      ..write(obj.diastolik3)
      ..writeByte(8)
      ..write(obj.rataSistolik)
      ..writeByte(9)
      ..write(obj.rataDiastolik)
      ..writeByte(10)
      ..write(obj.nadi)
      ..writeByte(11)
      ..write(obj.kondisi)
      ..writeByte(12)
      ..write(obj.aktivitas);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BloodPressureModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
