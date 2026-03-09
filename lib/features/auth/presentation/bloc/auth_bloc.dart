import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/domain/usecases/get_current_user.dart';
import 'package:myapp/features/auth/domain/usecases/login.dart';
import 'package:myapp/features/auth/domain/usecases/logout.dart';
import 'package:myapp/features/auth/domain/usecases/signup.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Signup signup;
  final Logout logout;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.login,
    required this.signup,
    required this.logout,
    required this.getCurrentUser,
  }) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await login(event.email, event.password);
      result.fold(
        (failure) => emit(AuthError(failure.toString())),
        (user) => emit(AuthAuthenticated(user)),
      );
    });

    on<SignupRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await signup(event.email, event.password);
      result.fold(
        (failure) => emit(AuthError(failure.toString())),
        (_) => emit(AuthUnauthenticated()),// After signup, user is not logged in
      );
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await logout();
      result.fold(
        (failure) => emit(AuthError(failure.toString())),
        (_) => emit(AuthUnauthenticated()),
      );
    });

    on<GetCurrentUserRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await getCurrentUser();
      result.fold(
        (failure) => emit(AuthUnauthenticated()),
        (user) => emit(AuthAuthenticated(user)),
      );
    });
  }
}
