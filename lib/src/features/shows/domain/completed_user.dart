import 'dart:ui';

class CompletedUser {
  const CompletedUser({
    required this.userId,
    required this.nickname,
    required this.completedShows,
    required this.color,
  });
  final int userId;
  final String nickname;
  final List<int> completedShows;
  final Color color;
}
