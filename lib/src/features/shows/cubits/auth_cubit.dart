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
        super(AuthCubitState());

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
    } catch (error) {
      Logger().d('Error: $error');
      emit(
        state.copyWith(
          status: AuthCubitStatus.error,
          errorMessage: 'Error!',
        ),
      );
    }
  }

  final FirebaseAuthRepository _firebaseAuthRepository;
}
