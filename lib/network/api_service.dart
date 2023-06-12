import 'package:either_dart/either.dart';

import '../data/repository/repository.dart';
import '../data/requests/login_request/login_request.dart';
import '../data/requests/ticket_report/ticket_report_request.dart';
import '../data/responses/hardware_data/hardware_data_response.dart';
import '../data/responses/ticket_category/ticket_category_response.dart';
import '../providers/app_state/app_state.dart';
import '../resources/string_manager.dart';
import '../utils/app_state_utils.dart';

abstract class ApiService {
  Future<HardwareData?> login({required LoginRequest loginRequest});
  Future<bool> logout();
  Future<List<TicketCategory>> getTicketCategories();
  Future<List<String>> postTicketReport({required List<TicketReportRequest> ticketReports});
}

class ApiServiceImpl implements ApiService {
  final Repository _repository;
  final AppStateUtils _appStateUtils;
  ApiServiceImpl(this._repository, this._appStateUtils);

  @override
  Future<HardwareData?> login({required LoginRequest loginRequest}) async {
    return await _repository.login(loginRequest).fold(
      (appError) {
        _appStateUtils.handleState(AppErrorState(appError: appError));
        return null;
      },
      (data) {
        _appStateUtils.handleState(AppEmitState(isLoading: false));
        return data;
      },
    );
  }

  @override
  Future<bool> logout() async {
    _appStateUtils.handleState(
      AppEmitState(
        isLoading: true,
        loadingMessage: AppLoadingString.logout,
      ),
    );

    return await _repository.logout().fold(
      (appError) {
        _appStateUtils.handleState(AppErrorState(appError: appError));
        return false;
      },
      (data) {
        _appStateUtils.handleState(AppEmitState(isLoading: false));
        return data;
      },
    );
  }

  @override
  Future<List<TicketCategory>> getTicketCategories() async {
    return await _repository.getTicketCategories().fold(
      (appError) {
        _appStateUtils.handleState(AppErrorState(appError: appError));
        return [];
      },
      (data) {
        _appStateUtils.handleState(AppEmitState(isLoading: false));
        return data;
      },
    );
  }

  @override
  Future<List<String>> postTicketReport({required List<TicketReportRequest> ticketReports}) async {
    _appStateUtils.handleState(
      AppEmitState(
        isLoading: true,
        loadingMessage: 'Saving Ticket',
      ),
    );
    return await _repository.postTicketReport(ticketReports).fold(
      (appError) {
        _appStateUtils.handleState(AppErrorState(appError: appError));
        return [];
      },
      (data) {
        _appStateUtils.handleState(AppEmitState(isLoading: false));
        return data;
      },
    );
  }
}
