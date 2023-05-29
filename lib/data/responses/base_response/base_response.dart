import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable()
class BaseResponse<T> {
  final int error;
  @JsonKey(name: 'errorMessage')
  final String errorMessage;
  final T? data;

  BaseResponse({
    required this.error,
    required this.errorMessage,
    this.data,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJson) => _$BaseResponseFromJson(json, fromJson);

  BaseResponse<T> copyWith({int? error, String? errorMessage, T? data}) {
    return BaseResponse<T>(
      error: error ?? this.error,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }
}
