import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/constants.dart';
import '../data/responses/ticket_category/ticket_category.dart';
import '../extensions/extensions.dart';
import '../network/api_future_providers.dart';
import '../providers/state_providers.dart';
import '../widgets/custom_error_builder.dart';
import '../widgets/custom_loading_indicator.dart';
import '../widgets/custom_selection_container.dart';
import '../widgets/slash_plus_bottom_bar.dart';

final homeScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldMessengerKey,
      appBar: AppBar(
        title: const Text(Constants.appTitle),
      ),
      body: SlashPlusBottomBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDefaults.contentPaddingSmall),
          width: double.infinity,
          child: Consumer(
            builder: (context, ref, child) {
              final ticketCategoriesFutureWatch = ref.watch(ticketCategoriesFutureProvider);

              final selectedTicketCategoryWatch = ref.watch(selectedTicketCategoryProvider);
              final selectedTicketCategoryNotifier = ref.watch(selectedTicketCategoryProvider.notifier);

              return ticketCategoriesFutureWatch.when(
                loading: () => const Center(child: CustomLoadingIndicator()),
                error: (error, stackTrace) => Center(child: CustomErrorBuilder(error: error.toString())),
                data: (ticketCategories) {
                  return Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceAround,
                    children: ticketCategories.map(
                      (category) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: AppDefaults.contentPaddingXSmall),
                          child: CustomSelectionContainer<TicketCategory>(
                            value: category,
                            onTap: (value) => selectedTicketCategoryNotifier.state = value,
                            isSelected: selectedTicketCategoryWatch == category,
                            title: category.name.orEmptyDashed(),
                          ),
                        );
                      },
                    ).toList(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
