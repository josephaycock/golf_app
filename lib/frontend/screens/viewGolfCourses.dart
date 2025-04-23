import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class ViewGolfCourses extends StatefulWidget {
  const ViewGolfCourses({super.key});

  @override
  State<ViewGolfCourses> createState() => _ViewGolfCoursesState();
}

class _ViewGolfCoursesState extends State<ViewGolfCourses> with AutomaticKeepAliveClientMixin {
  int _currentScore = 0;
  double? _calculatedDistance;
  LatLng? _currentLocation;
  LatLng? _holePosition;

  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _ensureLocationPermission();

    final position = await Geolocator.getCurrentPosition();
    final userLatLng = LatLng(position.latitude, position.longitude);
    setState(() {
      _currentLocation = userLatLng;
    });

    _mapController.move(userLatLng, 19.0);
  }

  Future<void> _ensureLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
  }

  void _onMapTap(LatLng tappedLocation) {
    setState(() {
      _holePosition = tappedLocation;
    });

    if (_currentLocation != null) {
      double distanceInMeters = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        tappedLocation.latitude,
        tappedLocation.longitude,
      );
      setState(() {
        _calculatedDistance = distanceInMeters / 1.09361;
      });
    }
  }

  void _recenterToUser() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 19.0);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: const Text('View Golf Course')),
      body: Column(
        children: [
          // Score UI
          Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: const Text('Current Score'),
              subtitle: Text('$_currentScore'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => setState(() => _currentScore--),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => _currentScore++),
                  ),
                ],
              ),
            ),
          ),

          // Distance UI
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: ListTile(
              title: const Text('Distance to Hole'),
              subtitle: Text(_calculatedDistance == null
                  ? 'Tap the map to place the flag'
                  : '${_calculatedDistance!.toStringAsFixed(1)} yards'),
            ),
          ),

          // Map section with rounded corners and green recenter button
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: _currentLocation ?? LatLng(29.9511, -90.0715),
                        zoom: 16.0,
                        onTap: (tapPosition, latLng) => _onMapTap(latLng),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            if (_currentLocation != null)
                              Marker(
                                width: 40,
                                height: 40,
                                point: _currentLocation!,
                                child: const Icon(Icons.person_pin_circle,
                                    color: Colors.blue, size: 36),
                              ),
                            if (_holePosition != null)
                              Marker(
                                width: 40,
                                height: 40,
                                point: _holePosition!,
                                child: const Icon(Icons.flag,
                                    color: Colors.red, size: 36),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: FloatingActionButton(
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        onPressed: _recenterToUser,
                        foregroundColor: Colors.blue,
                        child: const Icon(Icons.my_location),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
