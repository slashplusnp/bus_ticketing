import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/models/ticket_price_model.dart';

class SelectedTicketPriceListNotifier extends StateNotifier<List<TicketPriceModel>> {
  SelectedTicketPriceListNotifier() : super(<TicketPriceModel>[]);

  void addPrice(TicketPriceModel priceModel) {
    state = [...state, priceModel];
  }

  void removePrice(UniqueKey uId) {
    state = [
      for (final priceModel in state)
        if (priceModel.uId != uId) priceModel
    ];
  }
}

final selectedTicketCategoryIndexProvider = StateProvider<int>((ref) => 0);
final selectedTicketPriceListProvider = StateNotifierProvider<SelectedTicketPriceListNotifier, List<TicketPriceModel>>((ref) {
  return SelectedTicketPriceListNotifier();
});

