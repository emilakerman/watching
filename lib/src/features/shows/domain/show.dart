import 'package:freezed_annotation/freezed_annotation.dart';

part 'show.freezed.dart';

@freezed
class Show with _$Show {
  const factory Show({
    required int id,
    required String name,
    required String type,
    required String language,
    required List<String> genres,
    required String summary,
  }) = _Show;

  factory Show.fromJsonShow(Map<String, dynamic> data) {
    return Show(
      id: data['id'] as int,
      name: data['name'] as String,
      type: data['type'] as String,
      language: data['language'] as String,
      genres: data['genres'] as List<String>,
      summary: data['summary'] as String,
    );
  }
}
