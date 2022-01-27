part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationLoaded extends AuthenticationState {
  final String token;
  final String refreshToken;

  const AuthenticationLoaded({required this.token, required this.refreshToken});
  @override
  List<Object> get props => [token, refreshToken];
}

class AuthenticationError extends AuthenticationState {
  final String errorType;

  const AuthenticationError(this.errorType);

  @override
  List<Object> get props => [errorType];
}
