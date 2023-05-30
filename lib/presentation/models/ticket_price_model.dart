import 'package:flutter/material.dart';

import '../../data/responses/ticket_category/ticket_category_response.dart';

class TicketPriceModel {
  final UniqueKey uId;
  final TicketCategory category;
  final int price;

  TicketPriceModel({
    required this.category,
    required this.price,
  }) : uId = UniqueKey();
}
