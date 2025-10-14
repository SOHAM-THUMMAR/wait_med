import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  int _selectedIndex = 1;
  final MapController _mapController = MapController();
  LatLng? _currentLocation;

  final List<Map<String, dynamic>> _hospitals = [];
  Map<String, dynamic>? _nearestHospital;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _initLocationAndFetch();
  }

  Future<void> _initLocationAndFetch() async {
    await _determinePosition(); // Get location first
    if (_currentLocation != null) {
      _fetchNearbyHospitals(_currentLocation!); // Fetch hospitals in background
    }
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng userLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentLocation = userLocation;
      });

      // Instantly move map — no waiting for hospitals
      _mapController.move(userLocation, 13);
    } catch (e) {
      debugPrint("Error determining position: $e");
    }
  }

  Future<void> _fetchNearbyHospitals(LatLng location,
      {double radius = 50000}) async {
    if (_isFetching) return;
    setState(() => _isFetching = true);

    try {
      final String query = '''
      [out:json][timeout:25];
      (
        node["amenity"="hospital"](around:$radius,${location.latitude},${location.longitude});
        way["amenity"="hospital"](around:$radius,${location.latitude},${location.longitude});
        relation["amenity"="hospital"](around:$radius,${location.latitude},${location.longitude});
      );
      out center;
      ''';

      final uri = Uri.parse(
          'https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List elements = data['elements'];

        if (elements.isEmpty) {
          setState(() {
            _hospitals.clear();
            _nearestHospital = null;
            _isFetching = false;
          });
          return;
        }

        final Distance distance = Distance();
        final hospitals = elements.map<Map<String, dynamic>>((element) {
          double lat = element['lat'] ?? element['center']?['lat'] ?? 0.0;
          double lon = element['lon'] ?? element['center']?['lon'] ?? 0.0;
          return {
            'name': element['tags']?['name'] ?? 'Unnamed Hospital',
            'lat': lat,
            'lng': lon,
            'address': element['tags']?['addr:street'] ?? 'No address',
            'website': element['tags']?['website'] ?? '',
            'hours': element['tags']?['opening_hours'] ?? 'Open 24 hours',
            'distance': distance(location, LatLng(lat, lon)),
          };
        }).toList();

        // Sort by distance & limit to 10 nearest hospitals
        hospitals.sort((a, b) => a['distance'].compareTo(b['distance']));

        setState(() {
          _hospitals
            ..clear()
            ..addAll(hospitals.take(10));
          _nearestHospital = _hospitals.isNotEmpty ? _hospitals.first : null;
        });
      }
    } catch (e) {
      debugPrint("Error fetching hospitals: $e");
    } finally {
      setState(() => _isFetching = false);
    }
  }

  List<Marker> _buildMarkers() {
    return _hospitals.map((hospital) {
      final bool isNearest = _nearestHospital != null &&
          _nearestHospital!['name'] == hospital['name'];

      return Marker(
        point: LatLng(hospital['lat'], hospital['lng']),
        width: 60,
        height: 60,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _nearestHospital = hospital;
            });
            Get.to(() => SubmitCrowdLevelScreen(
                  name: hospital['name'],
                  website: hospital['website'],
                  address: hospital['address'],
                  hours: hospital['hours'],
                ));
          },
          child: Icon(
            Icons.local_hospital,
            color: isNearest ? Colors.greenAccent : AppTheme.errorColor,
            size: 35,
          ),
        ),
      );
    }).toList();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) {
      Get.toNamed('/map');
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasHospitals = _hospitals.isNotEmpty;

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
          // Nearest Hospital Card
          if (_nearestHospital != null)
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
                  children: [
                    Text(
                      _nearestHospital!['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _nearestHospital!['address'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _nearestHospital!['hours'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_isFetching)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            )
          else
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No hospitals found nearby.",
                style: TextStyle(color: Colors.grey),
              ),
            ),

          // Map
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
                          initialZoom: 13,
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
                          if (hasHospitals) MarkerLayer(markers: _buildMarkers()),
                        ],
                      ),
              ),
            ),
          ),

          // All Hospitals Header
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
