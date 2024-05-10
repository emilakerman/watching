import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';

@freezed
class Settings with _$Settings {
  const factory Settings({
    required int userId,
    required bool isPublic,
    required String nickname,
  }) = _Settings;
}
