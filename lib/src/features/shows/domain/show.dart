import 'package:freezed_annotation/freezed_annotation.dart';

part 'show.freezed.dart';
part 'show.g.dart';

// Define a new class for Image data
@freezed
class Image with _$Image {
  const factory Image({
    String? medium,
    String? original,
  }) = _Image;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}

// Update the Show class to use Image
@freezed
class Show with _$Show {
  const factory Show({
    required int id,
    required String name,
    required String type,
    required String language,
    required List<String> genres,
    required String summary,
    required Image? image, // Use the new Image class
  }) = _Show;

  factory Show.fromJson(Map<String, Object?> json) => _$ShowFromJson(json);
}
