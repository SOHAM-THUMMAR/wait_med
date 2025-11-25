import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

import '../Controller/map_controller.dart';
import '../widgets/hospital_marker.dart';
import '../widgets/search_bar.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../core/app_theme.dart';
import '../services/search_history_service.dart';

class OpenStreetMapScreen extends StatelessWidget {
  const OpenStreetMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapScreenController());
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          "Hospital Locations",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      body: Stack(
        children: [
          // MAP VIEW
          Obx(
            () => FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: LatLng(22.3039, 70.8022),
                initialZoom: 12,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.waitmed.app',
                ),
                const CurrentLocationLayer(),
                MarkerLayer(
                  markers: HospitalMarker.buildMarkers(controller.allHospitals),
                ),
              ],
            ),
          ),

          // SEARCH BAR
          HospitalSearchBar(
            controller: searchController,
            onSearch: () async {
              final query = searchController.text.trim();

              if (query.isNotEmpty) {
                // 🔥 Save to SQLite
                await SearchHistoryService.saveSearch(query);

                // 🔥 Run original search
                controller.searchHospitals(query);

                print("Saved search: $query");
              }
            },
          ),

          // LOADING INDICATOR
          Obx(() => LoadingIndicator(isVisible: controller.isLoading.value)),
        ],
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Get.toNamed('/home');
          } else if (index == 2) {
            Get.toNamed('/account');
          }
        },
      ),
    );
  }
}
