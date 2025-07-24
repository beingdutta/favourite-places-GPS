import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:favourite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

Future<Database> _getDatabase() async {
  // Creation of SQL database.
  final dbPath = await sql.getDatabasesPath();
  final database = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
      );
    },
    version: 1,
  );
  // End Database Creation.
  return database;
}

// For managing complex dtype's state mgmt. StateNotifier to be used.
class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data.map((row) => Place(
      id: row['id'] as String,
      title: row['title'] as String,
      image: File(row['image'] as String),
      location: PlaceLocation(
        latitude: row['lat'] as double,
        longitude: row['lng'] as double,
        address: row['address'] as String,
      ),
    )).toList();

    state = places;
  }


  void addPlace(String title, File image, PlaceLocation location) async {
    // Image Saving Code
    final appDirectory = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDirectory.path}/$fileName');
    // End of saving

    final newPlace = Place(title: title, image: copiedImage, location: location);

    final createdDB = await _getDatabase();

    // Add data to the Table of the SQL.
    createdDB.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [...state, newPlace];
  }
}

// Initialize the provider:
// It basically telling riverpod that "I want a provider that uses
// UserPlacesNotifier to manage a List<Place>."

final userPlacesProvider = 
StateNotifierProvider<UserPlacesNotifier, List<Place>>((ref) => UserPlacesNotifier());
