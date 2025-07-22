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
        child: Text(
          place.title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          )
        ),
      ),
    );
  }
}
