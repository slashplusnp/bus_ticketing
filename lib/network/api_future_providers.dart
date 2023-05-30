import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/dependency_injection.dart';
import '../data/responses/ticket_category/ticket_category.dart';
import 'api_service.dart';

final ticketCategoriesFutureProvider = FutureProvider<List<TicketCategory>>((ref) async {
  final ApiService apiService = getInstance<ApiService>();

  return apiService.getTicketCategories();
});
