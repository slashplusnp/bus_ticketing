import '../../network/app_service_client.dart';
import '../requests/login_request/login_request.dart';
import '../responses/hardware_data/hardware_data_response.dart';
import '../responses/ticket_category/ticket_category_response.dart';

abstract class RemoteDataSource {
  Future<HardwareDataResponse> login(LoginRequest loginRequest);
  Future<void> logout();
  Future<TicketCategoryResponse> getTicketCategories();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;
  RemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<HardwareDataResponse> login(LoginRequest loginRequest) {
    return _appServiceClient.login(loginRequest.identifier);
  }

  @override
  Future<void> logout() async {}

  @override
  Future<TicketCategoryResponse> getTicketCategories() {
    return _appServiceClient.getTicketCategories();
  }
}
