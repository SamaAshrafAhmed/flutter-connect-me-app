import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static const _members = <_MemberLocation>[
    _MemberLocation(
      name: 'Maya Hassan',
      city: 'Cairo',
      position: LatLng(30.0444, 31.2357),
    ),
    _MemberLocation(
      name: 'Omar Khalil',
      city: 'London',
      position: LatLng(51.5074, -0.1278),
    ),
    _MemberLocation(
      name: 'Sara Ahmed',
      city: 'New York',
      position: LatLng(40.7128, -74.0060),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final markers = _members
        .map(
          (member) => Marker(
            markerId: MarkerId(member.city),
            position: member.position,
            infoWindow: InfoWindow(title: member.name, snippet: member.city),
          ),
        )
        .toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('Community Map')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(30.0444, 31.2357),
          zoom: 1.5,
        ),
        markers: markers,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
      ),
    );
  }
}

class _MemberLocation {
  final String name;
  final String city;
  final LatLng position;

  const _MemberLocation({
    required this.name,
    required this.city,
    required this.position,
  });
}
