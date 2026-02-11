import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import 'package:order_tracking_app/core/constants/user_data.dart';
import 'package:order_tracking_app/feature/auth/data/repo/auth_repo.dart';
import 'package:order_tracking_app/feature/auth/presentation/cubit/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _authRepo = AuthRepo();

  bool get isLoading => state is LoginLoading;

  void emitLoginStates() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      emit(const LoginError(message: "Email and password are required"));
      return;
    }

    log('Starting login for: $email');
    emit(LoginLoading());

    try {
      final result = await _authRepo.loginUser(
        email: email,
        password: password,
      );

      result.fold(
        ifLeft: (error) {
          log('Login failed: $error');
          emit(LoginError(message: error));
        },
        ifRight: (userModel) {
          log('Login successful: ${userModel.uid}');
          UserData.userModel = userModel;
          emit(const LoginSuccess(message: 'Logged in successfully'));
          clearFields();
        },
      );
    } catch (e, stackTrace) {
      log('Unexpected error in LoginCubit: $e');
      log('StackTrace: $stackTrace');
      emit(LoginError(message: "Login failed: $e"));
    }
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  void resetState() {
    emit(LoginInitial());
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
