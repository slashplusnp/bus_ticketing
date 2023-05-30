import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/responses/ticket_category/ticket_category.dart';

final selectedTicketCategoryProvider = StateProvider<TicketCategory?>((ref) => null);