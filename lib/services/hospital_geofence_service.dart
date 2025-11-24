// lib/services/hospital_geofence_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'notification_service.dart';
import 'location_service.dart';

class HospitalGeofenceService {
  // meters
  final double radiusMeters;
  // how often to query OpenStreetMap (in seconds)
  final int queryIntervalSeconds;

  // Prevent repeated notifications for same hospital within cooldown
  final Duration _notificationCooldown = const Duration(minutes: 30);
  final Map<String, DateTime> _lastNotified = {};

  StreamSubscription<Position>? _positionSub;
  Timer? _periodicQueryTimer;

  HospitalGeofenceService({
    this.radiusMeters = 200.0,
    this.queryIntervalSeconds = 15,
  });

  void startMonitoring() async {
    // Start listening to position updates
    _positionSub = LocationService.positionStream().listen((position) {
      _onLocationUpdated(position);
    }, onError: (e) {
      // handle errors silently for now
    });

    // also run a periodic query in case position stream is sparse
    _periodicQueryTimer =
        Timer.periodic(Duration(seconds: queryIntervalSeconds), (_) async {
      try {
        final pos = await LocationService.getCurrentPosition();
        await _onLocationUpdated(pos);
      } catch (e) {
        // ignore
      }
    });
  }

  void stopMonitoring() {
    _positionSub?.cancel();
    _positionSub = null;
    _periodicQueryTimer?.cancel();
    _periodicQueryTimer = null;
  }

  Future<void> _onLocationUpdated(Position pos) async {
    try {
      final nearbyHospitals =
          await _fetchHospitalsFromOverpass(pos.latitude, pos.longitude, radiusMeters);

      for (final h in nearbyHospitals) {
        final double lat = h['lat'];
        final double lon = h['lon'];
        final String id = h['id'].toString();

        final double distance = Geolocator.distanceBetween(
            pos.latitude, pos.longitude, lat as double, lon as double);

        if (distance <= radiusMeters) {
          // cooldown check
          final DateTime now = DateTime.now();
          final last = _lastNotified[id];
          if (last != null && now.difference(last) < _notificationCooldown) {
            continue; // already notified recently
          }

          // Build payload
          final payload = {
            "id": id,
            "name": h['tags']?['name'] ?? 'Nearby Hospital',
            "latitude": lat,
            "longitude": lon,
            "address": _buildAddressFromTags(h['tags']),
            "website": h['tags']?['website'] ?? '',
            "hours": h['tags']?['opening_hours'] ?? '',
          };

          await NotificationService.showNotificationWithPayload(
            title: "Help others — quick request",
            body:
                "Help others by telling us how crowded ${payload['name']} is",
            payload: payload,
          );

          _lastNotified[id] = DateTime.now();
        }
      }
    } catch (e) {
      // ignore errors for now
    }
  }

  String _buildAddressFromTags(Map<String, dynamic>? tags) {
    if (tags == null) return '';
    final parts = <String>[];
    if (tags['addr:street'] != null) parts.add(tags['addr:street']);
    if (tags['addr:housenumber'] != null) parts.add(tags['addr:housenumber']);
    if (tags['addr:city'] != null) parts.add(tags['addr:city']);
    if (parts.isEmpty && tags['name'] != null) return tags['name'];
    return parts.join(', ');
  }

  /// Uses Overpass API to fetch nodes/ways tagged hospital within radius
  Future<List<Map<String, dynamic>>> _fetchHospitalsFromOverpass(
      double lat, double lon, double radiusMeters) async {
    // Overpass QL: search for amenity=hospital or healthcare=hospital
    final String query = '''
[out:json][timeout:10];
(
  node["amenity"="hospital"](around:$radiusMeters,$lat,$lon);
  way["amenity"="hospital"](around:$radiusMeters,$lat,$lon);
  node["healthcare"="hospital"](around:$radiusMeters,$lat,$lon);
  way["healthcare"="hospital"](around:$radiusMeters,$lat,$lon);
);
out center tags;
''';

    final response = await http.post(
      Uri.parse('https://overpass-api.de/api/interpreter'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'data': query},
    );

    if (response.statusCode != 200) {
      return [];
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final elements = jsonBody['elements'] as List<dynamic>? ?? [];

    // Normalize ways (they have .center), nodes have lat/lon
    final List<Map<String, dynamic>> results = [];
    for (final e in elements) {
      final Map<String, dynamic> el = Map<String, dynamic>.from(e);
      if (el.containsKey('center')) {
        final center = Map<String, dynamic>.from(el['center']);
        el['lat'] = center['lat'];
        el['lon'] = center['lon'];
      }
      results.add(el);
    }

    return results;
  }
}
