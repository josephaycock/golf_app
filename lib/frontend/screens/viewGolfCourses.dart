import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class ViewGolfCourses extends StatefulWidget {
  const ViewGolfCourses({super.key});

  @override
  State<ViewGolfCourses> createState() => _ViewGolfCoursesState();
}

class _ViewGolfCoursesState extends State<ViewGolfCourses>
    with AutomaticKeepAliveClientMixin {
  double? _calculatedDistance;
  bool _useYards = true;

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
    _mapController.move(_currentLocation, 19.0);

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
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
  }

  void _onMapTap(LatLng tappedLocation) {
    setState(() {
      _holePosition = tappedLocation;
      _calculatedDistance = Geolocator.distanceBetween(
        _currentLocation.latitude,
        _currentLocation.longitude,
        tappedLocation.latitude,
        tappedLocation.longitude,
      );
    });
  }

  void _recenterToUser() {
    _mapController.move(_currentLocation, 19.0);
  }

  @override
  bool get wantKeepAlive => true;

  String _recommendClub() {
    if (_calculatedDistance == null) {
      return 'Tap the map to place the flag';
    }

    // Example logic to recommend a club based on distance (in yards)
    double distanceInYards = _calculatedDistance! / 1.09361;

    if (distanceInYards < 100) {
      return 'Wedge';
    } else if (distanceInYards < 200) {
      return 'Iron';
    } else {
      return 'Driver';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/titleImage.png', height: 100),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/greenbg.png', fit: BoxFit.cover),
          ),
          Column(
            children: [
              // Distance to Hole card (now first)
              Card(
                elevation: 6,
                margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Distance to Hole'),
                        subtitle: Text(
                          _calculatedDistance == null
                              ? 'Tap the map to place the flag'
                              : _useYards
                                  ? '${(_calculatedDistance! / 1.09361).toStringAsFixed(1)} yards'
                                  : '${_calculatedDistance!.toStringAsFixed(1)} meters',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: ToggleButtons(
                            isSelected: [_useYards, !_useYards],
                            onPressed: (int index) {
                              setState(() {
                                _useYards = index == 0;
                              });
                            },
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Text('Yards', style: TextStyle(fontSize: 12)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Text('Meters', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Recommended Club card (new card)
              Card(
                elevation: 6,
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                color: Colors.white,
                child: ListTile(
                  title: const Text('Recommended Club'),
                  subtitle: Text(_recommendClub()),
                ),
              ),

              // Map
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              center: _currentLocation,
                              zoom: 16.0,
                              onTap: (tapPosition, latLng) =>
                                  _onMapTap(latLng),
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
                                    child: const Icon(
                                      Icons.person_pin_circle,
                                      color: Colors.blue,
                                      size: 36,
                                    ),
                                  ),
                                  if (_holePosition != null)
                                    Marker(
                                      width: 40,
                                      height: 40,
                                      point: _holePosition!,
                                      child: const Icon(
                                        Icons.flag,
                                        color: Colors.red,
                                        size: 36,
                                      ),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
