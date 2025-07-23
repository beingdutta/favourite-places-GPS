import 'dart:io';
import 'package:favourite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// For managing complex dtype's state mgmt. StateNotifier to be used.
class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void addPlace(String title, File image, PlaceLocation location) {
    final newPlace = Place(
      title: title,
      image: image,
      location: location
    );
    state = [...state, newPlace];
  }
}

// Initialize the provider:
// It basically telling riverpod that "I want a provider that uses 
// UserPlacesNotifier to manage a List<Place>."

final userPlacesProvider = StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier()
);
