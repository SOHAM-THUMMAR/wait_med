import 'package:cloud_firestore/cloud_firestore.dart';

class Hospital {
  final String name;
  final double lat;
  final double lng;
  final String website;
  final String address;
  final String hours;

  final int? crowdLevel;
  final DateTime? lastUpdated;

  Hospital({
    required this.name,
    required this.lat,
    required this.lng,
    required this.website,
    required this.address,
    required this.hours,
    this.crowdLevel,
    this.lastUpdated,
  });

  // From Firestore (only crowd data)
  factory Hospital.fromFirestore(String id, Map<String, dynamic> data) {
    return Hospital(
      name: data['hospitalName'],
      lat: (data['location'] as GeoPoint).latitude,
      lng: (data['location'] as GeoPoint).longitude,

      // The rest comes empty or from OSM (not Firestore)
      website: "",
      address: "",
      hours: "Open 24 hours",

      crowdLevel: data['crowdLevel'],
      lastUpdated:
          data['lastUpdated'] != null ? (data['lastUpdated'] as Timestamp).toDate() : null,
    );
  }
}
