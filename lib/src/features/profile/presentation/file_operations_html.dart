import 'dart:html' as html;
import 'package:image_picker/image_picker.dart';

Future<html.Blob> getFileFromImagePicker(XFile pickedFile) async {
  final bytes = await pickedFile.readAsBytes();
  return html.Blob([bytes]);
}
