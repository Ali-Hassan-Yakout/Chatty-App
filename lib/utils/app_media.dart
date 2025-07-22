import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AppMedia {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 800,
      maxWidth:  800,
    );

    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }
}
