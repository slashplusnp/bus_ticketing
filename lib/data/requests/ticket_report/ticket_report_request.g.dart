// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_report_request.dart';

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
