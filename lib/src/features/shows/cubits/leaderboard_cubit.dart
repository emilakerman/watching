import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:watching/src/src.dart';

part 'leaderboard_cubit.freezed.dart';

enum LeaderboardCubitStatus { initial, loading, error, success }

@freezed
class LeaderboardCubitState with _$LeaderboardCubitState {
  factory LeaderboardCubitState({
    @Default(LeaderboardCubitStatus.initial) LeaderboardCubitStatus status,
    List<CompletedUser>? users,
    String? errorMessage,
  }) = _LeaderboardCubitState;

  const LeaderboardCubitState._();
  bool get isLoading => status == LeaderboardCubitStatus.loading;
  bool get isError => status == LeaderboardCubitStatus.error;
  bool get isSuccess => status == LeaderboardCubitStatus.success;

  CompletedUser? getUserById() {
    final FirebaseAuthRepository firebaseAuthRepo = FirebaseAuthRepository();
    final int userId = firebaseAuthRepo.getUser()!.uid.hashCode;
    // Error handling if user is not the in settings table.
    return users?.firstWhere(
      (user) => user.userId == userId,
      orElse: () => const CompletedUser(
        userId: 1111111111111111,
        completedShows: [],
        nickname: 'Anonymous',
        color: Colors.grey,
      ),
    );
  }
}

class LeaderboardCubit extends Cubit<LeaderboardCubitState> {
  LeaderboardCubit({required SupabaseServices supabaseServices})
      : _supabaseServices = supabaseServices,
        super(LeaderboardCubitState()) {
    fetchAllPublicUsers();
  }

  Future<void> fetchAllPublicUsers() async {
    emit(state.copyWith(status: LeaderboardCubitStatus.loading));
    try {
      final users = await _supabaseServices.fetchAllPublicUsers();
      users.sort(
        (a, b) => b.completedShows.length.compareTo(a.completedShows.length),
      );
      emit(
        state.copyWith(
          status: LeaderboardCubitStatus.success,
          users: users,
        ),
      );
    } catch (error) {
      Logger().d('Error fetching all public users: $error');
      emit(
        state.copyWith(
          status: LeaderboardCubitStatus.error,
          errorMessage: 'Error fetching all public users',
        ),
      );
    }
  }

  final SupabaseServices _supabaseServices;
}
