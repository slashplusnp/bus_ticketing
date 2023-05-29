import 'package:flutter/material.dart' show Widget, immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(Widget content);

@immutable
class LoadingWidgetController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingWidgetController({
    required this.close,
    required this.update,
  });
}
