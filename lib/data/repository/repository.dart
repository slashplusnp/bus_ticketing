import 'package:either_dart/either.dart';

import '../../extensions/extensions.dart';
import '../../network/error_handler.dart';
import '../../network/network_info.dart';
import '../../resources/hive_box_manager.dart';
import '../data_sources/remote_data_source.dart';
import '../hive/hive_utils.dart';
import '../requests/login_request/login_request.dart';
import '../responses/hardware_data/hardware_data_response.dart';
import '../responses/ticket_category/ticket_category.dart';

abstract class Repository {
  Future<Either<AppError, HardwareData?>> login(LoginRequest loginRequest);
  Future<Either<AppError, bool>> logout();
  Future<Either<AppError, List<TicketCategory>>> getTicketCategories();
}

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  RepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<AppError, HardwareData?>> login(LoginRequest loginRequest) async {
    if (!(await _networkInfo.isConnected)) return const Left(AppErrorNoInternetConnection());

    try {
      final response = await _remoteDataSource.login(loginRequest);

      final userData = response.data;

      if (userData != null) {
        HiveUtils.storeToObjectBox<HardwareData>(
          boxName: HiveBoxManager.hardwareDataBox,
          boxModel: userData,
        );
      }
      return Right(response.data);
    } catch (error) {
      return Left(AppError.fromError(error));
    }
  }

  @override
  Future<Either<AppError, bool>> logout() async {
    if (!(await _networkInfo.isConnected)) return const Left(AppErrorNoInternetConnection());

    try {
      await _remoteDataSource.logout();
      HiveUtils.clearBox<HardwareData>(
        boxName: HiveBoxManager.hardwareDataBox,
      );

      return const Right(true);
    } catch (error) {
      return Left(AppError.fromError(error));
    }
  }
  
  @override
  Future<Either<AppError, List<TicketCategory>>> getTicketCategories() async {
    if (!(await _networkInfo.isConnected)) return const Left(AppErrorNoInternetConnection());

    try {
      final response = await _remoteDataSource.getTicketCategories();

      return Right(response.data.orEmpty());
    } catch (error) {
      return Left(AppError.fromError(error));
    }
  }
}
