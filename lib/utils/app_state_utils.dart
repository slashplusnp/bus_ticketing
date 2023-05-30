import 'package:flutter/material.dart';

import '../app/root_app.dart';
import '../data/hive/hive_utils.dart';
import '../data/responses/hardware_data/hardware_data_response.dart';
import '../network/error_handler.dart';
import '../presentation/pages/home_page.dart';
import '../providers/app_state/app_state.dart';
import '../resources/hive_box_manager.dart';
import '../resources/routes_manager.dart';
import '../presentation/widgets/dialogs/custom_dialog.dart';
import '../presentation/widgets/dialogs/loading_widget.dart';

class AppStateUtils {
  void handleState(AppState appState) {
    final context = navigatorKey.currentContext;
    final homeScaffoldContext = homeScaffoldMessengerKey.currentContext;

    if (context == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeScaffoldContext != null) {
        if (appState.isLoading) {
          LoadingWidget.instance().showLoading(
            context: homeScaffoldContext,
            text: (appState as AppEmitState).loadingMessage,
          );
        } else {
          LoadingWidget.instance().hide();
        }
      }
    });

    final appError = appState.appError;
    if (appError == null) return;
    switch (appError.runtimeType) {
      case AppErrorServerDown:
        CustomDialog.instance().showServerMaintenanceBreakError(
          context: context,
          appError: appError,
        );
        break;
      case AppErrorNoInternetConnection:
        CustomDialog.instance()
            .showAppError(
              context: context,
              appError: appError,
              actionText: 'Refresh',
            )
            .then((refresh) {});
        break;
      case AppErrorUserUnauthenticated:
        CustomDialog.instance()
            .showAppError(
          context: context,
          appError: appError,
        )
            .then(
          (okay) {
            if (okay) {
              HiveUtils.clearBox<HardwareData>(boxName: HiveBoxManager.hardwareDataBox);
              Navigator.of(context).pushNamedAndRemoveUntil(Routes.login.name, (route) => false);
            }
          },
        );
        break;
      default:
        CustomDialog.instance()
            .showAppError(
              context: context,
              appError: appError,
            )
            .then((okay) {});
    }
  }
}
