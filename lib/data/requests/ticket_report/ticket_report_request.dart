// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ticket_report_request.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class ReportTicketCategory {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int count;
  @HiveField(3)
  final int total;
  ReportTicketCategory({
    required this.id,
    required this.name,
    required this.count,
    required this.total,
  });

  factory ReportTicketCategory.fromJson(Map<String, dynamic> json) => _$ReportTicketCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ReportTicketCategoryToJson(this);

  ReportTicketCategory copyWith({
    int? id,
    String? name,
    int? count,
    int? total,
  }) {
    return ReportTicketCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      count: count ?? this.count,
      total: total ?? this.total,
    );
  }
}

@HiveType(typeId: 3)
@JsonSerializable()
class TicketReportRequest {
  @HiveField(0)
  final String date;
  @HiveField(1)
  final String uuid;
  @HiveField(2)
  final int deviceId;
  @HiveField(3)
  final int total;
  @HiveField(4)
  final List<ReportTicketCategory> category;
  @HiveField(5)
  final int tripCount;
  TicketReportRequest({
    required this.date,
    required this.uuid,
    required this.deviceId,
    required this.total,
    required this.category,
    required this.tripCount,
  });

  factory TicketReportRequest.fromJson(Map<String, dynamic> json) => _$TicketReportRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TicketReportRequestToJson(this);


  TicketReportRequest copyWith({
    String? date,
    String? uuid,
    int? deviceId,
    int? total,
    List<ReportTicketCategory>? category,
    int? tripCount,
  }) {
    return TicketReportRequest(
      date: date ?? this.date,
      uuid: uuid ?? this.uuid,
      deviceId: deviceId ?? this.deviceId,
      total: total ?? this.total,
      category: category ?? this.category,
      tripCount: tripCount ?? this.tripCount,
    );
  }
}
