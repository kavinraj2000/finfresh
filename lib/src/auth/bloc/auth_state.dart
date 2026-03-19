part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failure,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String message;

  const AuthState({
    required this.status,
    this.user,
    this.message = '',
  });

  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.initial,
      user: null,
      message: '',
    );
  }

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, user, message];
}
