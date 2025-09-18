// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/app_theme.dart';

class OpenStreetMapScreen extends StatelessWidget {
  const OpenStreetMapScreen({super.key});

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
        options: MapOptions(
          initialCenter: LatLng(22.3039, 70.8022), // Rajkot
          initialZoom: 12,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.waitmed.app',
          ),
          MarkerLayer(
            markers: [
              // Main location marker
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
              // Hospital markers - Sample hospitals in Rajkot
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
    );
  }
}
