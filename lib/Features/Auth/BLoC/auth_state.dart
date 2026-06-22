abstract class AuthState {}

class AuthInitial extends AuthState {
  final bool isPasswordVisible;

  AuthInitial({this.isPasswordVisible = true});
}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String userLoginName;
  AuthSuccess(this.userLoginName);
}

class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  List<Object?> get props => [message];
}
