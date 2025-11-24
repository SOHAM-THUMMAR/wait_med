import 'package:geofence_service/geofence_service.dart';
import 'package:geofence_service/models/geofence.dart';
import 'package:geofence_service/models/geofence_radius.dart';
import 'package:geofence_service/models/geofence_status.dart';
import 'package:fl_location/fl_location.dart';

import 'notification_service.dart';

class GeofenceHelper {
  static final GeofenceService _service = GeofenceService.instance;

  /// Start geofencing for all hospitals (5 km radius)
  static Future<void> startGeofencing(List<Map<String, dynamic>> hospitals) async {
    final List<Geofence> geofences = hospitals.map((hospital) {
      return Geofence(
        id: hospital['name'],
        latitude: hospital['lat'],
        longitude: hospital['lng'],
        radius: [
          GeofenceRadius(id: '5km', length: 5000),
        ],
      );
    }).toList();

    // Add geofence listener
    _service.addGeofenceStatusChangeListener(
      (Geofence geofence, GeofenceRadius radius, GeofenceStatus status, Location location) async {
        if (status == GeofenceStatus.ENTER) {
          NotificationService.showNotification(
            "Nearby Hospital",
            "You are within 5 km of ${geofence.id}",
          );
        }
      },
    );

    // Start service
    await _service.start(geofences);
  }
}
