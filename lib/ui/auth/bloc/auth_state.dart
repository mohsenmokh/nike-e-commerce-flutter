part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  final bool isLoginMode;
  const AuthState(this.isLoginMode);

  @override
  List<Object> get props => [isLoginMode];
}

class AuthInitial extends AuthState {
  const AuthInitial(super.isLoginMode);
}

class AuthLoading extends AuthState {
  const AuthLoading(super.isLoginMode);
}

class AuthError extends AuthState {
  final AppException exception;
  const AuthError(super.isLoginMode, this.exception);
}

class AuthSuccess extends AuthState {
  const AuthSuccess(super.isLoginMode);
}
