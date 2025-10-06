import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // <- add this
import 'package:get/get.dart';
import '../model/hospital_model.dart';
import '../screens/submit_crowd_level_screen.dart';

class HospitalMarker {
  static List<Marker> buildMarkers(List<Hospital> hospitals) {
    return hospitals.map((hospital) {
      // Defensive: handle double or string lat/lng
      final double lat = (hospital.lat is double)
          ? hospital.lat
          : double.tryParse(hospital.lat.toString()) ?? 0.0;
      final double lng = (hospital.lng is double)
          ? hospital.lng
          : double.tryParse(hospital.lng.toString()) ?? 0.0;

      return Marker(
        point: LatLng(lat, lng),
        width: 60,
        height: 60,
        child: GestureDetector(
          onTap: () {
            Get.to(() => SubmitCrowdLevelScreen(
                  name: hospital.name,
                  website: hospital.website,
                  address: hospital.address,
                  hours: hospital.hours,
                ));
          },
          child: const Icon(
            Icons.local_hospital,
            color: Colors.red,
            size: 35,
          ),
        ),
      );
    }).toList();
  }
}
