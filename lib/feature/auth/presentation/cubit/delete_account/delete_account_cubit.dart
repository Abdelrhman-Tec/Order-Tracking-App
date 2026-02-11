import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracking_app/feature/auth/data/repo/auth_repo.dart';
import 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(const DeleteAccountInitial());

  final AuthRepo _authRepo = AuthRepo();

  Future<void> emitDeleteAccountStates() async {
    emit(const DeleteAccountLoading());

    try {
      final result = await _authRepo.deleteUser();

      result.fold(
        ifLeft: (error) {
          emit(DeleteAccountError(message: error));
        },
        ifRight: (message) {
          emit(DeleteAccountSuccess(message: message));
        },
      );
    } catch (e) {
      emit(DeleteAccountError(message: 'Unexpected error: $e'));
    }
  }
}
