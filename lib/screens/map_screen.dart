import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
<<<<<<< HEAD
import 'package:http/http.dart' as http;
import 'package:wait_med/widgets/bottom_navigation_bar.dart';
=======
import '../widgets/bottom_navigation_bar.dart';
import 'submit_crowd_level_screen.dart';
>>>>>>> 31c948a91d91115e6dc23b336d8a2868e9dab7cd
import '../core/app_theme.dart';

class OpenStreetMapScreen extends StatefulWidget {
  const OpenStreetMapScreen({super.key});

  @override
  State<OpenStreetMapScreen> createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  int _currentIndex = 0;
<<<<<<< HEAD
  List<Marker> hospitalMarkers = [];
=======
  final MapController _mapController = MapController();
>>>>>>> 31c948a91d91115e6dc23b336d8a2868e9dab7cd

  @override
  void initState() {
    super.initState();
    _handleLocationPermission();
    _loadHospitals();
  }

  Future<void> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
<<<<<<< HEAD
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.');
      return;
    }
=======
    if (!serviceEnabled) return;
>>>>>>> 31c948a91d91115e6dc23b336d8a2868e9dab7cd

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error', 'Location permissions are permanently denied.');
      return;
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

<<<<<<< HEAD
  Future<void> _loadHospitals() async {
    try {
      final url = Uri.parse(
          'https://api.healthsites.io/v3/healthsites?geometry={"type":"Polygon","coordinates":[[[70.78,22.29],[70.83,22.29],[70.83,22.32],[70.78,22.32],[70.78,22.29]]]}&tags=amenity:hospital');

      final response = await http.get(url, headers: {
        'Authorization': 'Token 7f3de0314500b6f80ad9785e47168201e4f66bda',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List features = data['features'];

        List<Marker> markers = features.map((feature) {
          double lat = feature['geometry']['coordinates'][1];
          double lng = feature['geometry']['coordinates'][0];
          String name = feature['properties']['name'] ?? 'Hospital';

          return Marker(
            point: LatLng(lat, lng),
            width: 50,
            height: 50,
            child: Tooltip(
              message: name,
              child: const Icon(
                Icons.local_hospital,
                color: Colors.red,
                size: 35,
              ),
            ),
          );
        }).toList();

        setState(() {
          hospitalMarkers = markers;
        });
      } else {
        Get.snackbar('Error', 'Failed to fetch hospitals.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
=======
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
>>>>>>> 31c948a91d91115e6dc23b336d8a2868e9dab7cd
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
<<<<<<< HEAD
          // Current location marker (works in older version)
          CurrentLocationLayer(),
          // Hospital markers
          MarkerLayer(markers: hospitalMarkers),
          // Optional fixed marker
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
            ],
=======
          CurrentLocationLayer(
            style: const LocationMarkerStyle(),
>>>>>>> 31c948a91d91115e6dc23b336d8a2868e9dab7cd
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
