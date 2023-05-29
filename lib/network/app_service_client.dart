import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../app/constants.dart';
import '../data/responses/hardware_data/hardware_data_response.dart';

part 'app_service_client.g.dart';

@RestApi(baseUrl: UrlConstants.versionUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST(UrlConstants.loginUrl)
  Future<HardwareDataResponse> login(
    @Field('identifier') String identifier,
  );
}
