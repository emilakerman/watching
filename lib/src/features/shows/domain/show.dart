import 'package:freezed_annotation/freezed_annotation.dart';

part 'show.freezed.dart';
part 'show.g.dart';

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

  factory Show.fromJson(Map<String, Object?> json) => _$ShowFromJson(json);
}
