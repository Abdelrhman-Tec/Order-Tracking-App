import 'package:equatable/equatable.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final String message;

  const RegisterSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError({required this.message});

  @override
  List<Object?> get props => [message];
}
