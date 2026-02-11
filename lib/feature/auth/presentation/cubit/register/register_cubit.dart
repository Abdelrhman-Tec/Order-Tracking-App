import 'package:dart_either/dart_either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracking_app/feature/auth/data/repo/auth_repo.dart';
import 'package:order_tracking_app/feature/auth/presentation/cubit/register/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final AuthRepo _authRepo = AuthRepo();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool get isLoading => state is RegisterLoading;

  Future<void> emitRegisterStates() async {
    emit(RegisterLoading());
    try {
      Either<String, String> result = await _authRepo.registerUser(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      result.fold(
        ifLeft: (error) {
          emit(RegisterError(message: error));
        },
        ifRight: (message) {
          emit(RegisterSuccess(message: message));
        },
      );
    } catch (e) {
      emit(RegisterError(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<void> close() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
