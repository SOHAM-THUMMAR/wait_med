import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';

import 'account_settings_screen.dart';
import '../core/app_theme.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'submit_crowd_level_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Home selected by default
  final MapController _mapController = MapController();
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);

      if (_currentLocation != null) {
        _mapController.move(_currentLocation!, 14);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Get.toNamed('/map');
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
      );
    }
  }

  List<Marker> _buildMarkers() {
    final hospitals = [
      {
        'name': 'Shree Giriraj Hospital',
        'lat': 22.2987,
        'lng': 70.7951,
        'website': 'shreegirirajhospital.com',
        'address': '27, Navjyot Park Society, Rajkot',
        'hours': 'Open 24 hours',
      },
      {
        'name': 'City Hospital',
        'lat': 22.3091,
        'lng': 70.8156,
        'website': 'cityhospital.com',
        'address': '10, MG Road, Rajkot',
        'hours': 'Open 24 hours',
      },
      {
        'name': 'Rajkot General Hospital',
        'lat': 22.3125,
        'lng': 70.7890,
        'website': 'rajkotgeneral.com',
        'address': '5, Ring Road, Rajkot',
        'hours': 'Open 24 hours',
      },
    ];

    return hospitals.map((hospital) {
      final double lat = hospital['lat'] as double;
      final double lng = hospital['lng'] as double;
      final String name = hospital['name'] as String;
      final String website = hospital['website'] as String;
      final String address = hospital['address'] as String;
      final String hours = hospital['hours'] as String;

      return Marker(
        point: LatLng(lat, lng),
        width: 60,
        height: 60,
        child: GestureDetector(
          onTap: () {
            Get.to(() => SubmitCrowdLevelScreen(
                  name: name,
                  website: website,
                  address: address,
                  hours: hours,
                ));
          },
          child: Icon(
            Icons.local_hospital,
            color: AppTheme.errorColor,
            size: 35,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WaitMed"),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Nearby Hospital Box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withAlpha(230),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Shree Giriraj Hospital",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "27, Navjyot Park Society, Navjyot Park Main Rd,\n150 Feet Ring Rd - 360005",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Map Container
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _currentLocation == null
                    ? const Center(child: CircularProgressIndicator())
                    : FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _currentLocation!,
                          initialZoom: 14,
                          minZoom: 3,
                          maxZoom: 18,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: const ['a', 'b', 'c'],
                            userAgentPackageName: 'com.waitmed.app',
                          ),
                          CurrentLocationLayer(
                            style: const LocationMarkerStyle(),
                          ),
                          MarkerLayer(markers: _buildMarkers()),
                        ],
                      ),
              ),
            ),
          ),

          // All Hospitals Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "All Hospitals",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
