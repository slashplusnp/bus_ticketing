// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketCategory _$TicketCategoryFromJson(Map<String, dynamic> json) =>
    TicketCategory(
      id: json['id'] as int,
      name: json['name'] as String?,
      discount: json['discount'] as String?,
      priceList:
          (json['price_list'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$TicketCategoryToJson(TicketCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'discount': instance.discount,
      'price_list': instance.priceList,
    };

TicketCategoryResponse _$TicketCategoryResponseFromJson(
        Map<String, dynamic> json) =>
    TicketCategoryResponse(
      error: json['error'] as int,
      errorMessage: json['errorMessage'] as String,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TicketCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TicketCategoryResponseToJson(
        TicketCategoryResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorMessage': instance.errorMessage,
      'data': instance.data,
    };
