import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracking_app/feature/auth/data/repo/auth_repo.dart';
import 'package:order_tracking_app/feature/auth/presentation/cubit/update_user_profile/update_user_profile_state.dart';

class UpdateUserProfileCubit extends Cubit<UpdateUserProfileState> {
  UpdateUserProfileCubit() : super(UpadteUserProfileInitial());

  final AuthRepo _authRepo = AuthRepo();

  void emitUpdateUserProfileStates({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    emit(UpdateUserProfileLoading());

    try {
      final result = await _authRepo.updateUserProfile(uid: uid, data: data);

      result.fold(
        ifLeft: (error) {
          emit(UpdateUserProfileError(message: error));
        },
        ifRight: (userModel) {
          emit(
            UpdateUserProfileSuccess(
              message: 'Profile updated successfully',
              userModel: userModel,
            ),
          );
        },
      );
    } catch (e) {
      emit(UpdateUserProfileError(message: 'Unexpected error: $e'));
    }
  }
}
