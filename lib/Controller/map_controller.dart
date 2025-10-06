import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../model/hospital_model.dart';
import '../API Service/hospital_service.dart';

class MapScreenController extends GetxController {
  final MapController mapController = MapController();
  var markers = <Hospital>[].obs;
  var isLoading = false.obs;

  final RxString searchQuery = ''.obs;

  void moveToLocation(double lat, double lng) {
    mapController.move(LatLng(lat, lng), 15);
  }

  Future<void> searchHospitals(String query) async {
    if (query.isEmpty) return;
    isLoading.value = true;
    searchQuery.value = query;

    final results = await HospitalService.searchHospitals(query);
    markers.assignAll(results);

    if (results.isNotEmpty) {
      moveToLocation(results[0].lat, results[0].lng);
    }

    isLoading.value = false;
  }

  List<Hospital> get allHospitals => markers;
}
