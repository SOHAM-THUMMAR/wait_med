import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/hospital_model.dart';
import '../screens/submit_crowd_level_screen.dart';

class HospitalMarker {
  static List<Marker> buildMarkers(List<Hospital> hospitals) {
    return hospitals.map((hospital) {
      final double lat = hospital.lat;
      final double lng = hospital.lng;

      return Marker(
        point: LatLng(lat, lng),
        width: 60,
        height: 60,
        child: GestureDetector(
          onTap: () => _openHospitalDetails(hospital),
          child: const Icon(
            Icons.local_hospital,
            color: Colors.red,
            size: 35,
          ),
        ),
      );
    }).toList();
  }

  // Show full hospital card with crowd-level
  static void _openHospitalDetails(Hospital hospital) async {
    final id = "${hospital.lat}_${hospital.lng}";
    final doc = await FirebaseFirestore.instance
        .collection("crowdLevel")
        .doc(id)
        .get();

    int? last;
    int? avg;
    DateTime? updated;

    if (doc.exists) {
      last = doc["crowdLevelLast"];
      avg = doc["crowdLevelAverage"];
      updated = (doc["lastUpdated"] as Timestamp).toDate();
    }

    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hospital.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Text("Address: ${hospital.address}"),
              Text("Hours: ${hospital.hours}"),
              Text("Website: ${hospital.website}"),
              const SizedBox(height: 10),
              Text("Latitude: ${hospital.lat}"),
              Text("Longitude: ${hospital.lng}"),

              const Divider(height: 30),
              const Text("Crowd Information:",
                  style: TextStyle(fontWeight: FontWeight.bold)),

              if (avg != null) Text("Average Crowd: $avg"),
              if (last != null) Text("Last Submitted: $last"),
              if (updated != null) Text("Last Updated: $updated"),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Get.to(() => SubmitCrowdLevelScreen(
                        name: hospital.name,
                        website: hospital.website,
                        address: hospital.address,
                        hours: hospital.hours,
                        latitude: hospital.lat,
                        longitude: hospital.lng,
                      ));
                },
                child: const Text("Submit New Crowd Level"),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
