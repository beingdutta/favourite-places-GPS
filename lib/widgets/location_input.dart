import 'dart:convert';
import 'package:favourite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {

  // Class vars.
  final void Function(PlaceLocation location) onSelectLocation;

  // Constructor
  const LocationInput({
    super.key,
    required this.onSelectLocation,
  });

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  // Class vars.
  PlaceLocation? _pickedLocation;
  bool _isLoadingLocation = false;

  // Dart getter function.
  String get mapLocationSnapshot {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final long = _pickedLocation!.longitude;
    final String apiUrl =
        'https://maps.geoapify.com/v1/staticmap'
        '?style=osm-bright-smooth'
        '&width=600'
        '&height=400'
        '&center=lonlat:$long,$lat'
        '&zoom=14.3497'
        '&marker=lonlat:$long,$lat;type:awesome;color:%23bb3f73;size:x-large;icon:paw'
        '|lonlat:$long,$lat;type:material;color:%234c905a;icon:tree;icontype:awesome'
        '|lonlat:$long,$lat;type:material;color:%234c905a;icon:tree;icontype:awesome'
        '&apiKey=533fc6a70ebc4cc2af0d4ca8f447f823';
    return apiUrl;
  }

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
    final lat = locationData.latitude;
    final long = locationData.longitude;

    if (lat == null || long == null) {
      return;
    }

    // Make Reverse Geo Coding API Request.
    // geocode.maps.co is used here for free.
    final url = Uri.parse(
      'https://geocode.maps.co/reverse?lat=$lat&lon=$long&api_key=6881121c6e318591591696vcqc46855'
    );
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    final address = responseData['display_name'];

    //
    setState(() {
      _pickedLocation = PlaceLocation(latitude: lat, longitude: long, address: address);
      _isLoadingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    // Default content
    Widget previewContent = Text(
      'No Location Chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        mapLocationSnapshot,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isLoadingLocation) {
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
          child: previewContent,
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
