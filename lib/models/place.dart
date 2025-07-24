import 'dart:io';
import 'package:uuid/uuid.dart';

const uuid = Uuid();


// Blueprint for Location Data.
class PlaceLocation {

  // Class Variables.
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}


class Place {
  Place({
    required this.title, 
    required this.image,
    required this.location,
    String? id
  }) : id = id?? uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}


