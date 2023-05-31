// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_report_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportTicketCategoryAdapter extends TypeAdapter<ReportTicketCategory> {
  @override
  final int typeId = 2;

  @override
  ReportTicketCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportTicketCategory(
      id: fields[0] as int,
      name: fields[1] as String,
      count: fields[2] as int,
      total: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ReportTicketCategory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.count)
      ..writeByte(3)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportTicketCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TicketReportRequestAdapter extends TypeAdapter<TicketReportRequest> {
  @override
  final int typeId = 3;

  @override
  TicketReportRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TicketReportRequest(
      date: fields[0] as String?,
      uuid: fields[1] as String?,
      deviceId: fields[2] as int?,
      total: fields[3] as int?,
      category: (fields[4] as List?)?.cast<ReportTicketCategory>(),
    );
  }

  @override
  void write(BinaryWriter writer, TicketReportRequest obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.deviceId)
      ..writeByte(3)
      ..write(obj.total)
      ..writeByte(4)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketReportRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportTicketCategory _$ReportTicketCategoryFromJson(
        Map<String, dynamic> json) =>
    ReportTicketCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      count: json['count'] as int,
      total: json['total'] as int,
    );

Map<String, dynamic> _$ReportTicketCategoryToJson(
        ReportTicketCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'count': instance.count,
      'total': instance.total,
    };

TicketReportRequest _$TicketReportRequestFromJson(Map<String, dynamic> json) =>
    TicketReportRequest(
      date: json['date'] as String?,
      uuid: json['uuid'] as String?,
      deviceId: json['device_id'] as int?,
      total: json['total'] as int?,
      category: (json['category'] as List<dynamic>?)
          ?.map((e) => ReportTicketCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TicketReportRequestToJson(
        TicketReportRequest instance) =>
    <String, dynamic>{
      'date': instance.date,
      'uuid': instance.uuid,
      'device_id': instance.deviceId,
      'total': instance.total,
      'category': instance.category?.map((e) => e.toJson()).toList(),
    };
