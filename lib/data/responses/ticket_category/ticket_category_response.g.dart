// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_category_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TicketCategoryAdapter extends TypeAdapter<TicketCategory> {
  @override
  final int typeId = 1;

  @override
  TicketCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TicketCategory(
      id: fields[0] as int,
      name: fields[1] as String?,
      discount: fields[2] as String?,
      priceList: (fields[3] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, TicketCategory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.discount)
      ..writeByte(3)
      ..write(obj.priceList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };
