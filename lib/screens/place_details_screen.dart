import 'package:flutter/material.dart';
import 'package:favourite_places/models/place.dart';


class PlaceDetailsScreen extends StatelessWidget {
  // Class vars.
  final Place place;

  const PlaceDetailsScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Center(
        child: Stack(
          children: [

            // Display image at bottom.(z-axis)
            Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

          ]
        )
      ),
    );
  }
}
