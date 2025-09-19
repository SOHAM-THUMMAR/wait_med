import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'submit_crowd_level_screen.dart';
import '../core/app_theme.dart';

class OpenStreetMapScreen extends StatefulWidget {
  const OpenStreetMapScreen({super.key});

  @override
  State<OpenStreetMapScreen> createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  int _currentIndex = 0;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _handleLocationPermission();
  }

  Future<void> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Get.toNamed('/home');
    } else if (index == 2) {
      Get.toNamed('/account');
    }
  }

  @override
  Widget build(BuildContext context) {
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
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(22.3039, 70.8022),
          initialZoom: 12,
          minZoom: 3,
          maxZoom: 18,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.waitmed.app',
          ),
          // ✅ Fixed: disable orientation sensor
          CurrentLocationLayer(
            followOnLocationUpdate: FollowOnLocationUpdate.always,
            turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
          ),

          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(22.3039, 70.8022),
                width: 60,
                height: 60,
                child: Icon(
                  Icons.location_pin,
                  color: AppTheme.primaryColor,
                  size: 40,
                ),
              ),
              Marker(
                point: LatLng(22.2987, 70.7951),
                width: 60,
                height: 60,
                child: Icon(
                  Icons.local_hospital,
                  color: AppTheme.errorColor,
                  size: 35,
                ),
              ),
              Marker(
                point: LatLng(22.3091, 70.8156),
                width: 60,
                height: 60,
                child: Icon(
                  Icons.local_hospital,
                  color: AppTheme.errorColor,
                  size: 35,
                ),
              ),
              Marker(
                point: LatLng(22.3125, 70.7890),
                width: 60,
                height: 60,
                child: Icon(
                  Icons.local_hospital,
                  color: AppTheme.errorColor,
                  size: 35,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
