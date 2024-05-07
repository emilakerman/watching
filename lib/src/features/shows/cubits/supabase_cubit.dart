import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:watching/src/src.dart';

part 'supabase_cubit.freezed.dart';

enum SupabaseCubitStatus { initial, loading, error, success }

@freezed
class SupabaseCubitState with _$SupabaseCubitState {
  factory SupabaseCubitState({
    @Default(SupabaseCubitStatus.initial) SupabaseCubitStatus status,
    @Default([]) List<Show> show,
    String? errorMessage,
  }) = _SupabaseCubitState;

  const SupabaseCubitState._();
  bool get isLoading => status == SupabaseCubitStatus.loading;
  bool get isError => status == SupabaseCubitStatus.error;
  bool get isSuccess => status == SupabaseCubitStatus.success;
}

class SupabaseCubit extends Cubit<SupabaseCubitState> {
  SupabaseCubit({required SupabaseServices supabaseServices})
      : _supabaseServices = supabaseServices,
        super(SupabaseCubitState());

  final FirebaseAuthRepository _authRepository = FirebaseAuthRepository();
  final ShowService _showService = ShowService(
    tvMazeRepository: TvMazeRepository(),
  );

  Future<void> getAllWatching() async {
    final userId = _authRepository.getUser()!.uid.hashCode;

    try {
      emit(state.copyWith(status: SupabaseCubitStatus.loading));
      final List<Show> fetchedShows = await _showService.getAllWatching(
        userId: userId,
      );
      emit(
        state.copyWith(
          status: SupabaseCubitStatus.success,
          show: fetchedShows,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: SupabaseCubitStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> getAllCompleted() async {
    final userId = _authRepository.getUser()!.uid.hashCode;

    try {
      emit(state.copyWith(status: SupabaseCubitStatus.loading));
      final List<Show> fetchedShows = await _showService.getAllCompleted(
        userId: userId,
      );
      emit(
        state.copyWith(
          status: SupabaseCubitStatus.success,
          show: fetchedShows,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: SupabaseCubitStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> getAllPlanToWatch() async {
    final userId = _authRepository.getUser()!.uid.hashCode;

    try {
      emit(state.copyWith(status: SupabaseCubitStatus.loading));
      final List<Show> fetchedShows = await _showService.getAllPlanToWatch(
        userId: userId,
      );
      emit(
        state.copyWith(
          status: SupabaseCubitStatus.success,
          show: fetchedShows,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: SupabaseCubitStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> removeShow({
    required int userId,
    required int showid,
  }) async {
    try {
      emit(state.copyWith(status: SupabaseCubitStatus.loading));
      await _supabaseServices.removeShow(
        userId: userId,
        showid: showid,
      );
      final List<Show> updatedList = List<Show>.from(state.show);
      updatedList.removeWhere((show) => show.id == showid);
      emit(
        state.copyWith(
          status: SupabaseCubitStatus.success,
          show: updatedList,
        ),
      );
      Logger().d("Show removed from Supabase");
    } catch (error) {
      Logger().d(error.toString());
      emit(
        state.copyWith(
          status: SupabaseCubitStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> addNewShow({
    required int userId,
    required int showid,
    required String showStatus,
    required Show show,
  }) async {
    try {
      emit(state.copyWith(status: SupabaseCubitStatus.loading));
      await _supabaseServices.addNewShow(
        userId: userId,
        showid: showid,
        showStatus: showStatus,
      );
      final List<Show> updatedList = List<Show>.from(state.show);
      if (state.show.any((s) => s.id == show.id)) {
        final List<Show> updatedList = List<Show>.from(state.show);
        updatedList.removeWhere((s) => s.id == show.id);
        emit(
          state.copyWith(
            status: SupabaseCubitStatus.success,
            show: updatedList,
          ),
        );
        return;
      }
      updatedList.add(show);
      emit(
        state.copyWith(
          status: SupabaseCubitStatus.success,
          show: updatedList,
        ),
      );
    } catch (error) {
      Logger().d(error.toString());
      emit(
        state.copyWith(
          status: SupabaseCubitStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  final SupabaseServices _supabaseServices;
}
