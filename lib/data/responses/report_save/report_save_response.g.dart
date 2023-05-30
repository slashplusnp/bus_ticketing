// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_save_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportSaveResponse _$ReportSaveResponseFromJson(Map<String, dynamic> json) =>
    ReportSaveResponse(
      error: json['error'] as int,
      errorMessage: json['errorMessage'] as String,
      data: (json['data'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ReportSaveResponseToJson(ReportSaveResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorMessage': instance.errorMessage,
      'data': instance.data,
    };
