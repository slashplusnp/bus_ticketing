import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
import '../../resources/color_manager.dart';
import '../../resources/hive_box_manager.dart';
import '../../resources/string_manager.dart';
import '../../resources/values_manager.dart';
import '../../utils/geofence_utils.dart';
import '../../utils/pos_pirnter_utils.dart';
import '../../utils/utils.dart';
import '../models/ticket_price_model.dart';
import '../widgets/custom_error_builder.dart';
import '../widgets/custom_loading_indicator.dart';
import '../widgets/custom_selection_container.dart';
import '../widgets/price_selection_card.dart';
import '../widgets/save_reset_buttons.dart';
import '../widgets/slash_plus_bottom_bar.dart';
import '../widgets/widget_utils/widget_utils.dart';

final homeScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _apiService = getInstance<ApiService>();
  bool _internetConnected = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hardwareData = HiveUtils.getFromObjectBox<HardwareData>(boxName: HiveBoxManager.hardwareDataBox);
      if (hardwareData != null) {
        final points = hardwareData.points.toLatLngList();
        if (points.isNotEmpty) {
          GeofenceUtils.initGeofenceService({'pointA': points.first, 'pointB': points.last});
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cleanUnsyncedReports();
      _clearPreviousTotals();
      _clearPreviousTrips();
    });

    InternetConnectionChecker().onStatusChange.listen((internetConnectionStatus) {
      if (internetConnectionStatus == InternetConnectionStatus.connected) {
        final ticketReportRequestBox = Hive.box<TicketReportRequest>(HiveBoxManager.ticketReportRequestBox);
        final ticketReportRequests = ticketReportRequestBox.values.toList();

        if (ticketReportRequests.isNotEmpty) {
          _apiService.postTicketReport(ticketReports: ticketReportRequests);
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _internetConnected = internetConnectionStatus == InternetConnectionStatus.connected;
        });
      });
    });
  }

  void _cleanUnsyncedReports() {
    final ticketReportRequestBox = Hive.box<TicketReportRequest>(HiveBoxManager.ticketReportRequestBox);
    final now = DateTime.now().toLocalTimeZone();
    List<TicketReportRequest> unsyncedReports = [];
    for (final report in ticketReportRequestBox.values) {
      if (unsyncedReports.where((r) => r.uuid == report.uuid && (r.date.toDateTime()?.isBefore(now)).orFalse()).isEmpty) {
        unsyncedReports.add(report);
      }
    }
    ticketReportRequestBox.clear().then(
      (value) {
        ticketReportRequestBox.addAll(unsyncedReports);
      },
    );
  }

  void _clearPreviousTotals() {
    final todayTotalBox = Hive.box<int>(HiveBoxManager.todayTotalBox);
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final keys = List<String>.from(todayTotalBox.keys);
    keys.removeWhere((key) => key == todayKey);

    todayTotalBox.deleteAll(keys);
  }

  void _clearPreviousTrips() {
    final tripCountBox = Hive.box<int>(HiveBoxManager.tripCountBox);
    final todayKey = DateTime.now().toyMd();

    final keys = List<String>.from(tripCountBox.keys);
    keys.removeWhere((key) => key == todayKey);

    tripCountBox.deleteAll(keys);
  }

  void _addToTodayTotal(int total) {
    final todayTotalBox = Hive.box<int>(HiveBoxManager.todayTotalBox);
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastTotal = todayTotalBox.get(todayKey).orZero();
    final newTotal = lastTotal + total;
    todayTotalBox.put(todayKey, newTotal);
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
                                alignment: WrapAlignment.end,
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
                          SizedBox(
                            width: AppSize.s40,
                            child: Text(
                              '($groupTotalPrice)',
                              softWrap: true,
                              textAlign: TextAlign.end,
                            ),
                          ),
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

                      final todayTripCount = HiveUtils.getTodayTripCount();

                      final now = DateTime.now().toLocalTimeZone();

                      final TicketReportRequest reportRequest = TicketReportRequest(
                        date: now.toyMdHmS(),
                        deviceId: (hardwareData?.id).orZero(),
                        total: totalPrice,
                        trip: todayTripCount,
                        uuid: '${Utils.generateUUID()}-${DateTime.now().millisecondsSinceEpoch}',
                        category: requestCategoryList,
                      );

                      final totalPassengers = reportRequest.category
                          .map(
                            (c) => c.count,
                          )
                          .fold(
                            0,
                            (a, b) => a + b,
                          );

                      final ApiService apiService = getInstance<ApiService>();

                      PosPrinterUtils.printTicket(
                        reportRequest: reportRequest,
                        hardwareData: hardwareData,
                        totalPassengers: totalPassengers.orZero(),
                      );
                      apiService.postTicketReport(ticketReports: [reportRequest]).then((_) {
                        return ref.invalidate(selectedTicketPriceListProvider);
                      }).then(
                        (value) {
                          return null;
                        },
                      );

                      _addToTodayTotal(reportRequest.total.orZero());
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
        alignment: WrapAlignment.center,
        spacing: AppDefaults.padding,
        runSpacing: AppDefaults.contentPaddingSmall,
        children: priceList.mapIndexed(
          (index, category) {
            final price = priceList.elementAt(index);

            return PriceSelectionCard(
              key: UniqueKey(),
              size: PriceSelectionCardSize.large,
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
      spacing: AppDefaults.padding,
      runSpacing: AppDefaults.contentPadding,
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

  @override
  Widget build(BuildContext context) {
    final hardwareData = HiveUtils.getFromObjectBox<HardwareData>(boxName: HiveBoxManager.hardwareDataBox);

    return Scaffold(
      key: homeScaffoldMessengerKey,
      appBar: AppBar(
        title: Column(
          children: [
            Text('${Constants.appTitle} (${(hardwareData?.busNumber).orEmptyDashed()})'),
            ValueListenableBuilder(
              valueListenable: HiveUtils.getBoxListenable<int>(boxName: HiveBoxManager.todayTotalBox),
              builder: (context, todayTotal, child) {
                final tripCount = HiveUtils.getTodayTripCount();

                final todayKey = DateTime.now().toyMd();
                final todaysTotal = (todayTotal.get(todayKey)).orZero();

                return Text(
                  'Today\'s Total: Rs. $todaysTotal (Trip $tripCount)',
                  style: context.bodySmall,
                );
              },
            ),
          ],
        ),
        actions: [
          _internetConnected
              ? Icon(
                  Icons.sync,
                  color: ColorManager.statusActive,
                )
              : Icon(
                  Icons.sync_disabled,
                  color: ColorManager.statusInactive,
                ),
          if (!_internetConnected)
            ValueListenableBuilder(
              valueListenable: HiveUtils.getBoxListenable<TicketReportRequest>(boxName: HiveBoxManager.ticketReportRequestBox),
              builder: (context, ticketReportRequestBox, child) {
                final ticketReportRequests = ticketReportRequestBox.values;

                return Padding(
                  padding: const EdgeInsets.only(right: AppSize.s10),
                  child: Text(
                    ticketReportRequests.length.toString(),
                    style: context.titleSmall,
                  ),
                );
              },
            ),
        ],
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
                  if (ticketCategories.isEmpty) return Container();
                  final ticketCategory = ticketCategories.elementAt(selectedTicketCategoryIndexWatch);
                  final priceList = ticketCategory.priceList.orEmpty();

                  return Column(
                    children: [
                      _getCategories(ticketCategories, selectedTicketCategoryIndexNotifier, selectedTicketCategoryIndexWatch),
                      const Divider(height: AppDefaults.paddingLarge),
                      Expanded(child: _getCategoryPriceList(priceList, selectedTicketPriceListNotifier, ticketCategory)),
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
}
