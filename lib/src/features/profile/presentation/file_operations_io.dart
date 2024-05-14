import 'dart:io';
import 'package:image_picker/image_picker.dart';

File getFileFromImagePicker(XFile pickedFile) {
  return File(pickedFile.path);
}
