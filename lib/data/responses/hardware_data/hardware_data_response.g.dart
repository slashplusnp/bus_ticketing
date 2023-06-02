// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hardware_data_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HardwareDataAdapter extends TypeAdapter<HardwareData> {
  @override
  final int typeId = 0;

  @override
  HardwareData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HardwareData(
      id: fields[0] as int?,
      busId: fields[1] as int?,
      name: fields[2] as String?,
      token: fields[3] as String?,
      busName: fields[4] as String?,
      busNumber: fields[5] as String?,
      routeName: fields[6] as String?,
      isCircular: fields[7] as int?,
      points: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HardwareData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.busId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.token)
      ..writeByte(4)
      ..write(obj.busName)
      ..writeByte(5)
      ..write(obj.busNumber)
      ..writeByte(6)
      ..write(obj.routeName)
      ..writeByte(7)
      ..write(obj.isCircular)
      ..writeByte(8)
      ..write(obj.points);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HardwareDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HardwareData _$HardwareDataFromJson(Map<String, dynamic> json) => HardwareData(
      id: json['id'] as int?,
      busId: json['bus_id'] as int?,
      name: json['name'] as String?,
      token: json['token'] as String?,
      busName: json['bus_name'] as String?,
      busNumber: json['bus_number'] as String?,
      routeName: json['route_name'] as String?,
      isCircular: json['is_circular'] as int?,
      points: json['points'] as String?,
    );

Map<String, dynamic> _$HardwareDataToJson(HardwareData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bus_id': instance.busId,
      'name': instance.name,
      'token': instance.token,
      'bus_name': instance.busName,
      'bus_number': instance.busNumber,
      'route_name': instance.routeName,
      'is_circular': instance.isCircular,
      'points': instance.points,
    };

HardwareDataResponse _$HardwareDataResponseFromJson(
        Map<String, dynamic> json) =>
    HardwareDataResponse(
      error: json['error'] as int,
      errorMessage: json['errorMessage'] as String,
      data: json['data'] == null
          ? null
          : HardwareData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HardwareDataResponseToJson(
        HardwareDataResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorMessage': instance.errorMessage,
      'data': instance.data?.toJson(),
    };
