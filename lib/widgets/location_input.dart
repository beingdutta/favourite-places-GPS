import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  // Class vars.
  Location? _pickedLocation;
  bool _isLoadingLocation = false;

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Show Spinner when location data is being loaded.
    setState(() {
      _isLoadingLocation = true;
    });

    locationData = await location.getLocation();

    setState(() {
      _isLoadingLocation = false;
    });

    print('Location Latitude Determined is: ${locationData.latitude}');
    print('Location Longitude Determined is: ${locationData.longitude}');
  }

  @override
  Widget build(BuildContext context) {

    Widget previewContent = Text(
      'No Location Chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
    );

    if (_isLoadingLocation){
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        // Container
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
          ),
          child: previewContent
        ),

        // A row after.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Text Btn 1
            TextButton.icon(
              onPressed: _getCurrentLocation,
              label: const Text('Get Current Location'),
              icon: Icon(Icons.location_on_rounded),
            ),

            // Text Btn 2
            TextButton.icon(
              onPressed: () {},
              label: const Text('Select On Map'),
              icon: Icon(Icons.location_on_rounded),
            ),
          ],
        ),
      ],
    );
  }
}
