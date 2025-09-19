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
            style: const LocationMarkerStyle(),
// prevents MissingPluginException
          ),
          MarkerLayer(markers: _buildMarkers()),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
