import 'package:json_annotation/json_annotation.dart';

import '../base_response/base_response.dart';

part 'report_save_response.g.dart';

@JsonSerializable()
class ReportSaveResponse extends BaseResponse<List<String>> {
  ReportSaveResponse({
    required super.error,
    required super.errorMessage,
    super.data,
  });

  factory ReportSaveResponse.fromJson(Map<String, dynamic> json) => _$ReportSaveResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReportSaveResponseToJson(this);
}
