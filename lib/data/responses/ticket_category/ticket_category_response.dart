import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../base_response/base_response.dart';

part 'ticket_category_response.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class TicketCategory extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? discount;
  @HiveField(3)
  final List<int>? priceList;

  TicketCategory({
    required this.id,
    this.name,
    this.discount,
    this.priceList,
  });

  factory TicketCategory.fromJson(Map<String, dynamic> json) => _$TicketCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$TicketCategoryToJson(this);

  TicketCategory copyWith({
    int? id,
    String? name,
    String? discount,
    List<int>? priceList,
  }) {
    return TicketCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      discount: discount ?? this.discount,
      priceList: priceList ?? this.priceList,
    );
  }
}

@JsonSerializable()
class TicketCategoryResponse extends BaseResponse<List<TicketCategory>> {
  TicketCategoryResponse({
    required super.error,
    required super.errorMessage,
    super.data,
  });

  factory TicketCategoryResponse.fromJson(Map<String, dynamic> json) => _$TicketCategoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TicketCategoryResponseToJson(this);
}
