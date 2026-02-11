import 'package:equatable/equatable.dart';

sealed class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  @override
  List<Object?> get props => [];
}

class DeleteAccountInitial extends DeleteAccountState {
  const DeleteAccountInitial();
}

class DeleteAccountLoading extends DeleteAccountState {
  const DeleteAccountLoading();
}

class DeleteAccountSuccess extends DeleteAccountState {
  final String message;

  const DeleteAccountSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteAccountError extends DeleteAccountState {
  final String message;

  const DeleteAccountError({required this.message});

  @override
  List<Object?> get props => [message];
}
