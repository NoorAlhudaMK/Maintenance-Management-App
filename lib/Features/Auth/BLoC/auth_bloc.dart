import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {

    on<TogglePasswordVisibility>((event, emit) {
      bool isCurrentlyVisible = true;

      if (state is AuthInitial) {
        isCurrentlyVisible = (state as AuthInitial).isPasswordVisible;
      } else {
        isCurrentlyVisible = true;
      }

      emit(AuthInitial(isPasswordVisible: !isCurrentlyVisible));
    });

    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());

      try {
        await Future.delayed(const Duration(seconds: 2));

        if (event.username.trim() == "admin" && event.password.trim() == "1234") {
          emit(AuthSuccess("أشرف شروفي"));
        } else {
          emit(AuthFailure("اسم المستخدم أو كلمة المرور غير صحيحة"));
          await Future.delayed(const Duration(milliseconds: 500));
          emit(AuthInitial());
        }
      } catch (e) {
        emit(AuthFailure("حدث خطأ في الاتصال"));
      }
    });

    on<LogoutRequested>((event, emit) {
      emit(AuthInitial());
    });
  }
}