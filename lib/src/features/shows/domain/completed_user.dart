class CompletedUser {
  const CompletedUser({
    required this.userId,
    required this.nickname,
    required this.completedShows,
  });
  final int userId;
  final String nickname;
  final List<int> completedShows;
}
