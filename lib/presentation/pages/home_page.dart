import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/constants.dart';
import '../../app/dependency_injection.dart';
import '../../data/hive/hive_utils.dart';
import '../../data/requests/ticket_report/ticket_report_request.dart';
import '../../data/responses/hardware_data/hardware_data_response.dart';
import '../../data/responses/ticket_category/ticket_category_response.dart';
import '../../extensions/build_context_extensions.dart';
import '../../extensions/extensions.dart';
import '../../network/api_future_providers.dart';
import '../../network/api_service.dart';
import '../../providers/state_providers.dart';
import '../../resources/hive_box_manager.dart';
import '../../resources/string_manager.dart';
import '../../resources/values_manager.dart';
import '../../utils/utils.dart';
import '../models/ticket_price_model.dart';
import '../widgets/custom_error_builder.dart';
import '../widgets/custom_loading_indicator.dart';
import '../widgets/custom_selection_container.dart';
import '../widgets/pos_printer_platform_widget.dart';
import '../widgets/price_selection_card.dart';
import '../widgets/save_reset_buttons.dart';
import '../widgets/slash_plus_bottom_bar.dart';
import '../widgets/widget_utils/widget_utils.dart';

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

              final selectedTicketPriceListNotifier = ref.watch(selectedTicketPriceListProvider.notifier);

              final selectedTicketCategoryIndexWatch = ref.watch(selectedTicketCategoryIndexProvider);
              final selectedTicketCategoryIndexNotifier = ref.watch(selectedTicketCategoryIndexProvider.notifier);

              return ticketCategoriesFutureWatch.when(
                loading: () => const Center(child: CustomLoadingIndicator()),
                error: (error, stackTrace) => Center(child: CustomErrorBuilder(error: error.toString())),
                data: (ticketCategories) {
                  final ticketCategory = ticketCategories.elementAt(selectedTicketCategoryIndexWatch);
                  final priceList = ticketCategory.priceList.orEmpty();

                  return Column(
                    children: [
                      _getCategories(ticketCategories, selectedTicketCategoryIndexNotifier, selectedTicketCategoryIndexWatch),
                      const Divider(height: AppDefaults.paddingLarge),
                      Expanded(
                        flex: 2,
                        child: _getCategoryPriceList(priceList, selectedTicketPriceListNotifier, ticketCategory),
                      ),
                      _getSelectedPrices(),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Consumer _getSelectedPrices() {
    return Consumer(
      builder: (context, ref, child) {
        final selectedTicketPriceListWatch = ref.watch(selectedTicketPriceListProvider);
        final selectedTicketPriceListNotifier = ref.watch(selectedTicketPriceListProvider.notifier);

        final groupedPrices = selectedTicketPriceListWatch.groupListsBy(
          (priceModel) => priceModel.category.name,
        );

        final prices = selectedTicketPriceListWatch.map((priceModel) => priceModel.price).toList();
        final totalPrice = prices.fold(0, (a, b) => a + b);

        return prices.isEmpty
            ? Container()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: AppDefaults.paddingLarge),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: groupedPrices.keys.map<Widget>((key) {
                      final priceModelList = groupedPrices[key].orEmpty();
                      final groupTotalPrice = priceModelList
                          .map(
                            (priceModel) => priceModel.price,
                          )
                          .fold(
                            0,
                            (a, b) => a + b,
                          );

                      return Row(
                        children: [
                          Text('$key (${priceModelList.length}):'),
                          WidgetUtils.horizontalSpace(AppSize.s2),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppDefaults.contentPaddingXXSmall),
                              child: Wrap(
                                spacing: AppDefaults.contentPaddingSmall,
                                runSpacing: AppDefaults.contentPaddingSmall / 2,
                                children: priceModelList
                                    .map<Widget>(
                                      (priceModel) => PriceSelectionCard(
                                        key: UniqueKey(),
                                        onTap: () => selectedTicketPriceListNotifier.removePrice(priceModel.uId),
                                        price: priceModel.price,
                                        action: PriceSelectionAction.remove,
                                        size: PriceSelectionCardSize.small,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                          WidgetUtils.horizontalSpace(AppSize.s2),
                          Text('($groupTotalPrice)'),
                        ],
                      );
                    }).toList(),
                  ),
                  const Divider(height: AppDefaults.paddingLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total (${selectedTicketPriceListWatch.length}):'),
                      Text(
                        '($totalPrice)',
                        style: context.titleSmall,
                      ),
                    ],
                  ),
                  const Divider(height: AppDefaults.paddingLarge),
                  SaveResetCancelButtons(
                    saveTitle: AppString.print,
                    onSave: () {
                      final hardwareData = HiveUtils.getFromObjectBox<HardwareData>(boxName: HiveBoxManager.hardwareDataBox);

                      log((hardwareData?.toJson()).toString());

                      final categoryGroupedTicketPrices = selectedTicketPriceListWatch.groupListsBy((ticket) => ticket.category);
                      final List<ReportTicketCategory> requestCategoryList = categoryGroupedTicketPrices.keys.map<ReportTicketCategory>(
                        (key) {
                          final tickets = categoryGroupedTicketPrices[key].orEmpty();
                          final name = key.name.orEmpty();
                          final count = tickets.length;
                          final total = tickets.map((ticket) => ticket.price).fold(0, (a, b) => a + b);

                          return ReportTicketCategory(
                            id: key.id,
                            name: name,
                            count: count,
                            total: total,
                          );
                        },
                      ).toList();

                      final TicketReportRequest reportRequest = TicketReportRequest(
                        date: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                        deviceId: (hardwareData?.id).orZero(),
                        total: totalPrice,
                        uuid: Utils.generateUUID(),
                        category: requestCategoryList,
                      );

                      final totalPassengers = reportRequest.category
                          ?.map(
                            (c) => c.count,
                          )
                          .fold(
                            0,
                            (a, b) => a + b,
                          );

                      context.navigator
                          .push<bool>(
                        MaterialPageRoute<bool>(
                          builder: (context) => PosPrinterPlatformWidget(
                            reportRequest: reportRequest,
                            hardwareData: hardwareData,
                            totalPassengers: totalPassengers.orZero(),
                          ),
                        ),
                      )
                          .then<void>(
                        (hasPrinted) {
                          if (hasPrinted.orFalse()) {
                            final ApiService apiService = getInstance<ApiService>();
                            apiService.postTicketReport(ticketReports: [reportRequest]).then(
                              (value) => ref.invalidate(selectedTicketPriceListProvider),
                            );
                          }
                        },
                      );
                    },
                  ),
                  WidgetUtils.verticalSpace(AppSize.s5),
                ],
              );
      },
    );
  }

  SizedBox _getCategoryPriceList(
    List<int> priceList,
    SelectedTicketPriceListNotifier selectedTicketPriceListNotifier,
    TicketCategory ticketCategory,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceAround,
        spacing: AppDefaults.contentPaddingSmall,
        runSpacing: AppDefaults.contentPaddingSmall / 2,
        children: priceList.mapIndexed(
          (index, category) {
            final price = priceList.elementAt(index);

            return PriceSelectionCard(
              key: UniqueKey(),
              onTap: () => selectedTicketPriceListNotifier.addPrice(
                TicketPriceModel(
                  category: ticketCategory,
                  price: price,
                ),
              ),
              price: price,
            );
          },
        ).toList(),
      ),
    );
  }

  Wrap _getCategories(
    List<TicketCategory> ticketCategories,
    StateController<int> selectedTicketCategoryIndexNotifier,
    int selectedTicketCategoryIndexWatch,
  ) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.spaceAround,
      spacing: AppDefaults.contentPaddingXXSmall,
      runSpacing: AppDefaults.contentPaddingXSmall,
      children: ticketCategories.mapIndexed(
        (index, category) {
          return CustomSelectionContainer<TicketCategory>(
            key: UniqueKey(),
            onTap: (_) => selectedTicketCategoryIndexNotifier.state = index,
            isSelected: selectedTicketCategoryIndexWatch == index,
            title: category.name.orEmptyDashed(),
          );
        },
      ).toList(),
    );
  }
}
