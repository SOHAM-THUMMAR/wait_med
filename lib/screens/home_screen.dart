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
  int _selectedIndex = 1; // Middle icon is selected initially (Home)
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

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_currentLocation!, 14);
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
    // ... (appBar and other widgets)
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nearby Hospital !",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 12),
          // This is the map container
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
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
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
          // Add a section for the list of hospitals below the map
          const SizedBox(height: 20),
          Text(
            "All Hospitals",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          // You would then add a ListView.builder or similar widget here
          // to display the hospital list dynamically.
          // For now, you can add a static list item for testing.
        ],
      ),
    ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
