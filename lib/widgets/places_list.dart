import 'package:flutter/material.dart';
import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/screens/place_details_screen.dart';

class PlacesList extends StatelessWidget {
  // Class variables
  final List<Place> places;

  const PlacesList({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          )
        )
      );
    }

    // Else case.
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: FileImage(
              places[index].image,
            ),
          ),
          title: Text(
            places[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            places[index].location.address,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          onTap:() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => PlaceDetailsScreen(
                  place: places[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
