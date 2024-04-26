import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:watching/src/features/shows/shows.dart';

part 'shows_cubit.freezed.dart';

enum ShowsCubitStatus { initial, loading, error, success }

@freezed
class ShowCubitState with _$ShowCubitState {
  factory ShowCubitState({
    @Default(ShowsCubitStatus.initial) ShowsCubitStatus status,
    @Default([]) List<Show> shows,
    String? errorMessage,
  }) = _ShowCubitState;

  const ShowCubitState._();
  bool get isLoading => status == ShowsCubitStatus.loading;
  bool get isError => status == ShowsCubitStatus.error;
  bool get isSuccess => status == ShowsCubitStatus.success;

  Show? getShowByName(String name) {
    return shows.firstWhereOrNull((show) => show.name == name);
  }
}

class ShowCubit extends Cubit<ShowCubitState> {
  ShowCubit({required ShowService showService})
      : _showService = showService,
        super(ShowCubitState()) {
    getAllShows();
  }

  Future<void> getAllShows() async {
    // TODO(Emil): This is a big fetch. We should consider perhaps only running this one once a day or so.
    // check right here if its been run today already, if so, dont run it again.
    try {
      emit(state.copyWith(status: ShowsCubitStatus.loading));
      final List<Show> fetchedShows = await _showService.getAllShows();
      emit(
        state.copyWith(
          status: ShowsCubitStatus.success,
          shows: fetchedShows,
        ),
      );
    } catch (error) {
      Logger().d(error.toString());
      emit(
        state.copyWith(
          status: ShowsCubitStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  // Filters the state of shows by genre passed in by the user.
  Future<void> filterByGenre({required String genre}) async {
    try {
      final List<Show> filteredShows = state.shows
          .where(
            (Show show) => show.genres.contains(genre),
          )
          .toList();
      emit(
        state.copyWith(
          status: ShowsCubitStatus.success,
          shows: filteredShows,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ShowsCubitStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  // Filters the state of shows by language passed in by the user.
  Future<void> filterByLanguage({required String language}) async {
    try {
      Logger().d('Filtering by language: $language');
      final List<Show> filteredShows = state.shows
          .where(
            (Show show) => show.language == language,
          )
          .toList();
      emit(
        state.copyWith(
          status: ShowsCubitStatus.success,
          shows: filteredShows,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ShowsCubitStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  final ShowService _showService;
}
