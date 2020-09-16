import 'package:bloc/bloc.dart';
import 'package:hello_enam/domain/auth/model/login_request.dart';
import 'package:hello_enam/domain/auth/model/login_response.dart';
import 'package:hello_enam/infrastucture/auth/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  AuthRepository _authRepository = AuthRepository();

  void siginUser(LoginRequest loginRequest) async {
    // 1. panggil state loading
    emit(AuthLoading());
    try {
      final _data = await _authRepository.siginUser(loginRequest: loginRequest);
      _data.fold(
        (l) => emit(AuthError(l)),
        (r) => emit(AuthSuccess(r)),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
