import 'package:freezed_annotation/freezed_annotation.dart';

part 'show.freezed.dart';
part 'show.g.dart';

// Define a new class for Image data
@freezed
class NetworkImage with _$NetworkImage {
  const factory NetworkImage({
    String? medium,
    String? original,
  }) = _NetworkImage;

  factory NetworkImage.fromJson(Map<String, dynamic> json) =>
      _$NetworkImageFromJson(json);
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
    required NetworkImage? image, // Use the new Image class
  }) = _Show;

  factory Show.fromJson(Map<String, Object?> json) => _$ShowFromJson(json);

  factory Show.fromJsonSearch(Map<String, dynamic> json) {
    return Show(
      id: json['show']['id'] as int,
      name: json['show']['name'] as String,
      type: json['show']['type'] as String,
      language: json['show']['language'] as String,
      genres: (json['show']['genres'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      summary: json['show']['summary'] as String,
      image: json['show']['image'] != null
          ? NetworkImage.fromJson(json['show']['image'] as Map<String, dynamic>)
          : null,
    );
  }
}
