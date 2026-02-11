import 'package:equatable/equatable.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final String message;

  const LoginSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message});

  @override
  List<Object?> get props => [message];
}
