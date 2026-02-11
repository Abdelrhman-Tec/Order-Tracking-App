import 'package:equatable/equatable.dart';
import 'package:order_tracking_app/feature/auth/data/model/user_model.dart';

abstract class UpdateUserProfileState extends Equatable {
  const UpdateUserProfileState();

  @override
  List<Object?> get props => [];
}

class UpadteUserProfileInitial extends UpdateUserProfileState {
  const UpadteUserProfileInitial();
}

class UpdateUserProfileLoading extends UpdateUserProfileState {
  const UpdateUserProfileLoading();
}

class UpdateUserProfileSuccess extends UpdateUserProfileState {
  final String message;
  final UserModel userModel;

  const UpdateUserProfileSuccess({
    required this.message,
    required this.userModel,
  });

  @override
  List<Object?> get props => [message, userModel];
}

class UpdateUserProfileError extends UpdateUserProfileState {
  final String message;

  const UpdateUserProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
