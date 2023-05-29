import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../base_response/base_response.dart';

part 'hardware_data_response.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class HardwareData {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final int? busId;
  @HiveField(2)
  final String? name;
  @HiveField(3)
  final String? token;
  @HiveField(4)
  final String? busName;
  @HiveField(5)
  final String? busNumber;
  @HiveField(6)
  final String? routeName;
  @HiveField(7)
  final int? isCircular;

  HardwareData({
    this.id,
    this.busId,
    this.name,
    this.token,
    this.busName,
    this.busNumber,
    this.routeName,
    this.isCircular,
  });

  factory HardwareData.fromJson(Map<String, dynamic> json) => _$HardwareDataFromJson(json);
  Map<String, dynamic> toJson() => _$HardwareDataToJson(this);

  HardwareData copyWith({
    int? id,
    int? busId,
    String? name,
    String? token,
    String? busName,
    String? busNumber,
    String? routeName,
    int? isCircular,
  }) {
    return HardwareData(
      id: id ?? this.id,
      busId: busId ?? this.busId,
      name: name ?? this.name,
      token: token ?? this.token,
      busName: busName ?? this.busName,
      busNumber: busNumber ?? this.busNumber,
      routeName: routeName ?? this.routeName,
      isCircular: isCircular ?? this.isCircular,
    );
  }
}

@JsonSerializable()
class HardwareDataResponse extends BaseResponse<HardwareData> {
  HardwareDataResponse({
    required super.error,
    required super.errorMessage,
    super.data,
  });
  factory HardwareDataResponse.fromJson(Map<String, dynamic> json) => _$HardwareDataResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HardwareDataResponseToJson(this);
}
