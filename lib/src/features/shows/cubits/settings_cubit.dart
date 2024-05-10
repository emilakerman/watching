import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:watching/src/src.dart';

part 'settings_cubit.freezed.dart';

enum SettingsCubitStatus { initial, loading, error, success }

@freezed
class SettingsCubitState with _$SettingsCubitState {
  factory SettingsCubitState({
    @Default(SettingsCubitStatus.initial) SettingsCubitStatus status,
    List<Settings>? settings,
    String? errorMessage,
  }) = _SettingsCubitState;

  const SettingsCubitState._();
  bool get isLoading => status == SettingsCubitStatus.loading;
  bool get isError => status == SettingsCubitStatus.error;
  bool get isSuccess => status == SettingsCubitStatus.success;

  Settings? getUserById() {
    final FirebaseAuthRepository firebaseAuthRepo = FirebaseAuthRepository();
    final int userId = firebaseAuthRepo.getUser()!.uid.hashCode;
    // Error handling if user is not the in settings table.
    return settings?.firstWhere(
      (user) => user.userId == userId,
      orElse: () => const Settings(
        userId: 1111111111111111,
        isPublic: false,
        nickname: 'Anonymous',
      ),
    );
  }
}

class SettingsCubit extends Cubit<SettingsCubitState> {
  SettingsCubit({required SupabaseServices supabaseServices})
      : _supabaseServices = supabaseServices,
        super(SettingsCubitState()) {
    fetchAllSettings();
  }

  Future<void> updateSettingsRowInSupabase({
    required int userId,
    required bool isPublic,
    required String nickName,
  }) async {
    emit(state.copyWith(status: SettingsCubitStatus.loading));
    try {
      await _supabaseServices.updateSettingsRowInSupabase(
        userId: userId,
        isPublic: isPublic,
        nickName: nickName,
      );
      emit(
        state.copyWith(
          status: SettingsCubitStatus.success,
          settings: state.settings?.map((setting) {
            if (setting.userId == userId) {
              return setting.copyWith(isPublic: isPublic, nickname: nickName);
            }
            return setting;
          }).toList(),
        ),
      );
      Logger().d('Settings updated in Supabase with isPublic: $isPublic');
    } catch (error) {
      emit(
        state.copyWith(
          status: SettingsCubitStatus.error,
          errorMessage: 'Error updating settings in supabase: $error',
        ),
      );
      Logger().d('Error updating settings in supabase: $error');
    }
  }

  Future<void> fetchAllSettings() async {
    emit(state.copyWith(status: SettingsCubitStatus.loading));
    try {
      final settings = await _supabaseServices.fetchAllSettings();
      emit(
        state.copyWith(
          status: SettingsCubitStatus.success,
          settings: settings,
        ),
      );
      Logger().d('All settings fetched: $settings');
    } catch (error) {
      Logger().d('Error fetching all settings: $error');
      emit(
        state.copyWith(
          status: SettingsCubitStatus.error,
          errorMessage: 'Error fetching all settings: $error',
        ),
      );
    }
  }

  final SupabaseServices _supabaseServices;
}
