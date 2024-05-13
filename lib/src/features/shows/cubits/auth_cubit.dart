import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:watching/src/src.dart';

part 'auth_cubit.freezed.dart';

enum AuthCubitStatus { initial, loading, error, success }

@freezed
class AuthCubitState with _$AuthCubitState {
  factory AuthCubitState({
    @Default(AuthCubitStatus.initial) AuthCubitStatus status,
    User? user,
    String? errorMessage,
  }) = _AuthCubitState;

  const AuthCubitState._();
  bool get isLoading => status == AuthCubitStatus.loading;
  bool get isError => status == AuthCubitStatus.error;
  bool get isSuccess => status == AuthCubitStatus.success;
}

class AuthCubit extends Cubit<AuthCubitState> {
  AuthCubit({required FirebaseAuthRepository firebaseAuthRepository})
      : _firebaseAuthRepository = firebaseAuthRepository,
        super(AuthCubitState()) {
    getUser();
  }

  Future<void> createUser(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthCubitStatus.loading));
    try {
      await _firebaseAuthRepository.createUser(
        email: email,
        password: password,
        context: context,
      );
      emit(
        state.copyWith(
          status: AuthCubitStatus.success,
          user: _firebaseAuthRepository.getUser(),
        ),
      );
      // IMPORTANT: Creates the user row in Supabase with uid.hashCode
      // as userId if the user is not already in the database.
      if (!await supabaseRepository.checkIfUserExistsInSupabase(
        userId: _firebaseAuthRepository.getUser()!.uid.hashCode,
      )) {
        await supabaseRepository.createUserRowInSupaBase(
          userId: _firebaseAuthRepository.getUser()!.uid.hashCode,
        );
      } else {
        return;
      }
    } catch (error) {
      Logger().d('Error: $error');
      emit(
        state.copyWith(
          status: AuthCubitStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> getUser() async {
    emit(state.copyWith(status: AuthCubitStatus.loading));
    try {
      final user = _firebaseAuthRepository.getUser();
      emit(
        state.copyWith(
          status: AuthCubitStatus.success,
          user: user,
        ),
      );
    } catch (error) {
      Logger().d('Error: $error');
      emit(
        state.copyWith(
          status: AuthCubitStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  SupabaseRepository get supabaseRepository => SupabaseRepository();

  Future<void> signInUser(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthCubitStatus.loading));
    try {
      await _firebaseAuthRepository.signInUser(
        email: email,
        password: password,
        context: context,
      );
      emit(
        state.copyWith(
          status: AuthCubitStatus.success,
          user: _firebaseAuthRepository.getUser(),
        ),
      );
      // IMPORTANT: Creates the user row in Supabase with uid.hashCode
      // as userId if the user is not already in the database.
      if (!await supabaseRepository.checkIfUserExistsInSupabase(
        userId: _firebaseAuthRepository.getUser()!.uid.hashCode,
      )) {
        await supabaseRepository.createUserRowInSupaBase(
          userId: _firebaseAuthRepository.getUser()!.uid.hashCode,
        );
      } else {
        return;
      }
    } catch (error) {
      Logger().d('Error: $error');
      emit(
        state.copyWith(
          status: AuthCubitStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  final FirebaseAuthRepository _firebaseAuthRepository;
}
