import 'package:equatable/equatable.dart';

sealed class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];
}

class LogoutInitial extends LogoutState {
  const LogoutInitial();
}

class LogoutLoading extends LogoutState {
  const LogoutLoading();
}

class LogoutSuccess extends LogoutState {
  final String message;

  const LogoutSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class LogoutError extends LogoutState {
  final String message;

  const LogoutError({required this.message});

  @override
  List<Object?> get props => [message];
}
