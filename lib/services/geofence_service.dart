import 'package:geofence_service/geofence_service.dart';
import '../services/notification_service.dart';

class GeofenceHelper {
  static final GeofenceService geofenceService = GeofenceService.instance;

  static Future<void> startGeofencing(List<Map<String, dynamic>> hospitals) async {
    final List<Geofence> geofences = [];

    for (var h in hospitals) {
      geofences.add(
        Geofence(
          id: h['name'],
          latitude: h['lat'],
          longitude: h['lng'],
          radius: [
            GeofenceRadius(id: '5km', length: 5000),
          ],
        ),
      );
    }

    /// Setup options (optional but recommended)
    geofenceService.setup(
      interval: 5000,
      accuracy: 100,
      loiteringDelayMs: 0,
      statusChangeDelayMs: 1000,
      useActivityRecognition: false,
      allowMockLocations: true,
      printDevLog: true,
    );

    /// Listen for geofence events — CORRECT SIGNATURE
    geofenceService.addGeofenceStatusChangeListener(
      (Geofence geofence, GeofenceRadius radius, GeofenceStatus status, Location location) async {

        if (status == GeofenceStatus.ENTER) {
          NotificationService.showNotification(
            "Nearby Hospital",
            "You are within 5 km of ${geofence.id}",
          );
        }

        if (status == GeofenceStatus.DWELL) {
          NotificationService.showNotification(
            "Still Near Hospital",
            "You are staying near ${geofence.id}",
          );
        }
      },
    );

    /// Listen for location updates (optional)
    geofenceService.addLocationChangeListener((Location location) {
      // print("Location updated: ${location.latitude}, ${location.longitude}");
    });

    /// Start the geofence service — CORRECT SYNTAX
    await geofenceService.start(geofences);
  }
}
