import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:favourite_places/models/place.dart';


class MapScreen extends StatefulWidget {
  // Class vars.
  final bool isSelecting;
  final PlaceLocation location;

  const MapScreen({
    super.key,
    this.location = const PlaceLocation(latitude: 37.422, longitude: -122.084, address: ''),
    this.isSelecting = true,
  });

  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  // Class vars.
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick Your Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            // Save Icon Btn
            IconButton(
              onPressed: () {
                Navigator.pop(context, _pickedLocation);
              },
              icon: const Icon(Icons.save_rounded),
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(widget.location.latitude, widget.location.longitude),
          initialZoom: 9.2,

          // Move the market if user
          // selects any region of the map.
          onTap: widget.isSelecting
              ? (tapPosition, latLng) {
                  setState(() {
                    _pickedLocation = latLng;
                  });
                }
              : null,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.yourapp.identifier',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _pickedLocation ?? LatLng(
                  widget.location.latitude, 
                  widget.location.longitude
                ),
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_on, 
                  color: Colors.red, size: 40
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
