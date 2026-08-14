abstract class AuthState {
  final bool isPasswordVisible;
  AuthState({this.isPasswordVisible = false});
}

class AuthInitial extends AuthState {
  AuthInitial({super.isPasswordVisible});
}

class AuthLoading extends AuthState {
  AuthLoading({super.isPasswordVisible});
}

class AuthSuccess extends AuthState {
  final String userName;
  final String role;
  AuthSuccess(this.userName, this.role, {super.isPasswordVisible});
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error, {super.isPasswordVisible});
}

class AuthUnauthenticated extends AuthState {
  final String message;
  AuthUnauthenticated(this.message, {super.isPasswordVisible});
}
