import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  Position? _currentPosition;

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission(context);

    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then(
      (value) {
        setState(() {
          _currentPosition = value;
        });

        _getAddressFromLatLng(value);
      },
    );
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission locationPermission;

    // cek apakah gps disable atau enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Locatin tidak di aktifkan, silahkan aktifkan terlebih dahulu,",
            ),
          ),
        );
      }
      return false;
    }
    locationPermission = await Geolocator.checkPermission();
    // cek permission di tolak atau tidak
    if (locationPermission == LocationPermission.denied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Ijin Lokasi di tolak",
            ),
          ),
        );
      }
      return false;
    }
    if (locationPermission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Ijin lokasi di tolak secara permanet, silahkan ubah settingan pada device',
            ),
          ),
        );
      }
      return false;
    }
    return true;
  }

  String? _currentAddress;

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    ).then(
      (value) {
        setState(() {
          Placemark placemark = value.first;
          _currentAddress =
              '${placemark.street} ${placemark.subLocality} ${placemark.subAdministrativeArea} ${placemark.postalCode}';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LAT: ${_currentPosition?.latitude ?? "-"}'),
              Text('LNG: ${_currentPosition?.longitude ?? "-"}'),
              Text('ADDRESS: ${_currentAddress ?? "-"} '),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _getCurrentPosition,
                child: const Text("Get Current Location"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
