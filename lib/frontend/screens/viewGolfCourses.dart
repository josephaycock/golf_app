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
  bool _useYards = true; // <-- Toggle between yards/meters

  // LSU Golf Course Hole 1
  final LatLng _currentLocation = LatLng(30.399895, -91.184794);
  LatLng? _holePosition;

  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _ensureLocationPermission();

    // Move to hardcoded location immediately
    _mapController.move(_currentLocation!, 19.0);

    // Still try to get user's real GPS position (not used now)
    try {
      final position = await Geolocator.getCurrentPosition();
      print('User location (GPS): ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Failed to get current location: $e');
    }
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
        _currentLocation.latitude,
        _currentLocation.longitude,
        tappedLocation.latitude,
        tappedLocation.longitude,
      );
      setState(() {
        _calculatedDistance = distanceInMeters;
      });
    }
  }

  void _recenterToUser() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation, 19.0);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: const Text('View Golf Course',
          style: TextStyle(
            color: Colors.white,
          )),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        automaticallyImplyLeading: false,
      ),
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
            child: Row(
              children: [
                // Distance label and value
                Expanded(
                  child: ListTile(
                    title: const Text('Distance to Hole'),
                    subtitle: Text(_calculatedDistance == null
                        ? 'Tap the map to place the flag'
                        : _useYards
                            ? '${(_calculatedDistance! / 1.09361).toStringAsFixed(1)} yards'
                            : '${_calculatedDistance!.toStringAsFixed(1)} meters'),
                  ),
                ),
                // Toggle Button on the far right with rounded edges and smaller size
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16), // Rounded edges
                    child: ToggleButtons(
                      isSelected: [_useYards, !_useYards],
                      onPressed: (int index) {
                        setState(() {
                          _useYards = index == 0;
                        });
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Yards',
                            style: TextStyle(fontSize: 12), // Smaller text size
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Meters',
                            style: TextStyle(fontSize: 12), // Smaller text size
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Map section with markers
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
                        center: _currentLocation!,
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
                            Marker(
                              width: 40,
                              height: 40,
                              point: _currentLocation,
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
