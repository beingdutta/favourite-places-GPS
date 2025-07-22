import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {

  // Class variable.
  final void Function(File image) onPickImage;

  const ImageInput({
    super.key,
    required this.onPickImage
  });

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {

  // Class variable
  File? _selectedImage;

  // Class Method
  void _takePicture() async{
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    // If the user just opens camera and doesn't click.
    if (pickedImage == null){
      return;
    }

    // Else case
    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    // Pass the image to the Parent Screen ('add_place_screen.dart')
    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {

    // Method Var.
    Widget containerContent = TextButton.icon(
      onPressed: _takePicture, 
      label: const Text('Take Picture'), 
      icon: Icon(Icons.camera)
    );
    
    // If there is an Image dont show the Text Btn.
    if (_selectedImage != null){
      containerContent = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1, 
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
        ),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: containerContent
    );
  }
}
