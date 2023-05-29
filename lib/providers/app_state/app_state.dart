import '../../../network/error_handler.dart';

abstract class AppState {
  final bool isLoading;
  final AppError? appError;
  const AppState({
    required this.isLoading,
    this.appError,
  });
}

class AppInitial extends AppState {
  AppInitial({
    super.isLoading = false,
  });
}

class AppEmitState extends AppState {
  final String loadingMessage;
  AppEmitState({
    required super.isLoading,
    this.loadingMessage = '',
  }) : assert(isLoading ? (loadingMessage != '') : true);
}

class AppErrorState extends AppState {
  AppErrorState({
    required AppError appError,
  }) : super(
          isLoading: false,
          appError: appError,
        );
}
