import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:watching/src/features/shows/shows.dart';

part 'supabase_cubit.freezed.dart';

enum SupabaseCubitStatus { initial, loading, error, success }

@freezed
class SupabaseCubitState with _$SupabaseCubitState {
  factory SupabaseCubitState({
    @Default(SupabaseCubitStatus.initial) SupabaseCubitStatus status,
    @Default([]) List<dynamic> show,
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
      emit(
        state.copyWith(
          status: SupabaseCubitStatus.success,
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
  }) async {
    try {
      emit(state.copyWith(status: SupabaseCubitStatus.loading));
      await _supabaseServices.addNewShow(
        userId: userId,
        showid: showid,
        showStatus: showStatus,
      );
      emit(
        state.copyWith(
          status: SupabaseCubitStatus.success,
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
