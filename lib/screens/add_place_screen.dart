import 'dart:io';
import 'package:favourite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:favourite_places/providers/user_places.dart';
import 'package:favourite_places/widgets/location_input.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  // Class Variables.
  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  final titleTextEditingController = TextEditingController();

  @override
  void dispose() {
    titleTextEditingController.dispose();
    super.dispose();
  }

  // Function to be passed to child widget
  void onSelectLocation(PlaceLocation location) {
    _selectedLocation = location; 
  }

  void _savePlace() {
    final enteredTitle = titleTextEditingController.text.trim();

    if (enteredTitle.isEmpty || _selectedImage == null || _selectedLocation == null) {
      return;
    }
    // Use the provider to add the new Place.
    ref.read(userPlacesProvider.notifier).addPlace(
      enteredTitle, 
      _selectedImage!,
      _selectedLocation!
    );
    Navigator.pop(context);
  }

  // Function to be passed to the Child Widget.
  void onPickImageParentScreen(image) {
    _selectedImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a New Place'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Place name field
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: titleTextEditingController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),

            // Vertical Spacing
            SizedBox(height: 10),

            // Image Input Btn.
            ImageInput(onPickImage: onPickImageParentScreen),

            // Vertical Spacing
            SizedBox(height: 10),

            // Location Input Btns
            LocationInput(onSelectLocation: onSelectLocation),

            // Vertical Spacing
            SizedBox(height: 10),

            // Add Btn.
            ElevatedButton.icon(onPressed: _savePlace, label: const Text('Add Place'), icon: const Icon(Icons.add)),
          ],
        ),
      ),
    );
  }
}
