class ReportTicketCategory {
  final int id;
  final int count;
  final int total;
  ReportTicketCategory({
    required this.id,
    required this.count,
    required this.total,
  });

  ReportTicketCategory copyWith({
    int? id,
    int? count,
    int? total,
  }) {
    return ReportTicketCategory(
      id: id ?? this.id,
      count: count ?? this.count,
      total: total ?? this.total,
    );
  }
}

class TicketReportRequest {
  final String? date;
  final String? uuid;
  final int? deviceId;
  final int? total;
  final List<ReportTicketCategory>? category;
  TicketReportRequest({
    this.date,
    this.uuid,
    this.deviceId,
    this.total,
    this.category,
  });

  TicketReportRequest copyWith({
    String? date,
    String? uuid,
    int? deviceId,
    int? total,
    List<ReportTicketCategory>? category,
  }) {
    return TicketReportRequest(
      date: date ?? this.date,
      uuid: uuid ?? this.uuid,
      deviceId: deviceId ?? this.deviceId,
      total: total ?? this.total,
      category: category ?? this.category,
    );
  }
}
