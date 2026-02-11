import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracking_app/feature/auth/data/repo/auth_repo.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(const LogoutInitial());

  final AuthRepo _authRepo = AuthRepo();

  Future<void> emitLogoutStates() async {
    emit(const LogoutLoading());

    try {
      final result = await _authRepo.logoutUser();

      result.fold(
        ifLeft: (error) {
          emit(LogoutError(message: error));
        },
        ifRight: (message) {
          emit(LogoutSuccess(message: message));
        },
      );
    } catch (e) {
      emit(LogoutError(message: 'Unexpected error: $e'));
    }
  }
}
