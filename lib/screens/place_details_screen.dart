import 'package:favourite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:favourite_places/models/place.dart';

class PlaceDetailsScreen extends StatelessWidget {
  // Class vars.
  final Place place;
  const PlaceDetailsScreen({super.key, required this.place});

  // Class Methods.
  // Dart getter function.
  String get mapLocationSnapshot {
    final lat = place.location.latitude;
    final long = place.location.longitude;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Center(
        child: Stack(
          children: [
            // Display image at bottom.(z-axis)
            Image.file(place.image, fit: BoxFit.cover, width: double.infinity, height: double.infinity),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Map Avatar
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => MapScreen(
                            location: place.location,
                            isSelecting: false,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 70, 
                      backgroundImage: NetworkImage(mapLocationSnapshot)
                    ),
                  ),

                  // Container to hold
                  // Human Readable Address.
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, const Color.fromARGB(137, 0, 0, 0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      place.location.address,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
