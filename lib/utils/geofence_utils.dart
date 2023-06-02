import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../app/constants.dart';
import '../extensions/extensions.dart';
import '../resources/hive_box_manager.dart';

class GeofenceUtils {
  static final _geofenceService = GeofenceService.instance.setup(
    interval: 5000,
    accuracy: 100,
    loiteringDelayMs: 60000,
    statusChangeDelayMs: 10000,
    useActivityRecognition: true,
    allowMockLocations: false,
    printDevLog: false,
    geofenceRadiusSortType: GeofenceRadiusSortType.DESC,
  );
  static final _geofenceStreamController = StreamController<Geofence>.broadcast();

  static List<Geofence> _generateGeofences(Map<String, LatLng> points) {
    List<Geofence> geofences = [];

    for (final key in points.keys) {
      final point = points[key];
      final lat = point?.latitude;
      final lon = point?.longitude;

      if (lat != null && lon != null) {
        geofences.add(
          Geofence(
            id: key,
            latitude: lat,
            longitude: lon,
            radius: [
              GeofenceRadius(
                id: 'radius_${AppDefaults.pointGeofenceRadiusInMeter}',
                length: AppDefaults.pointGeofenceRadiusInMeter,
              ),
            ],
          ),
        );
      }
    }

    return geofences;
  }

  static Future<void> _onGeofenceStatusChanged(
    Geofence geofence,
    GeofenceRadius geofenceRadius,
    GeofenceStatus geofenceStatus,
    Location location,
  ) async {
    final tripCountBox = Hive.box<int>(HiveBoxManager.tripCountBox);
    final todayKey = DateTime.now().toyMd();
    final todayTripCount = tripCountBox.get(todayKey).orZero();
    tripCountBox.put(todayKey, todayTripCount + 1);

    _geofenceStreamController.sink.add(geofence);
  }

  static void _onError(dynamic error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      debugPrint('Undefined error: $error');
      return;
    }
    debugPrint('ErrorCode: $errorCode');
  }

  static void initGeofenceService(Map<String, LatLng> points) {
    _geofenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
    _geofenceService.addStreamErrorListener(_onError);
    _geofenceService
        .start(
          _generateGeofences(points),
        )
        .onError(
          (error, stackTrace) => _onError(error),
        );
  }

  static void disposeGeofenceService() {
    GeofenceService.instance.stop();

    _geofenceService.removeGeofenceStatusChangeListener(_onGeofenceStatusChanged);
    _geofenceService.removeStreamErrorListener(_onError);
    _geofenceService.clearAllListeners();
    _geofenceService.stop();
  }
}
