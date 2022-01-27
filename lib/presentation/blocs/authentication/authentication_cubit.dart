import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:traveller_ratings/data/repositories/auth_repo.dart';
import 'package:traveller_ratings/data/shared_pref/prefs.dart';
import 'package:traveller_ratings/domain/entities/app_error.dart';
import 'package:traveller_ratings/presentation/blocs/loading/loading_cubit.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final LoadingCubit loadingCubit;

  AuthenticationCubit({
    required this.loadingCubit,
  }) : super(AuthenticationInitial());

  Future<void> authenticateUser(Map query) async {
    loadingCubit.show();

    emit(AuthenticationLoading());

    await Prefs.setEmail(query['email']);
    await Prefs.setUserName(query['username']);
    await Prefs.setFirstName('');
    await Prefs.setLastName('');
    await Prefs.setPassword(query['password']);

    final response = await AuthRepo.signupUser(query);
    if (response['email'] != null) {
      final resToken = await AuthRepo.getUserToken({
        "username": query['username'],
        "password": query['password'],
      });
      if (resToken['access'] != null) {
        await Prefs.setToken(resToken['access']);
        await Prefs.setRefreshToken(resToken['refresh']);
        await Prefs.setIsNewUser(false);
        emit(
          AuthenticationLoaded(
              refreshToken: resToken['refresh'], token: resToken['access']),
        );
      }
    }
    if (response['message'] == "Token has expired") {
      final responseToken = await AuthRepo.getUserToken({
        "username": query['username'],
        "password": query['password'],
      });
      if (responseToken['access'] != null) {
        await Prefs.setToken(responseToken['access']);
        await Prefs.setRefreshToken(responseToken['refresh']);
        await Prefs.setIsNewUser(false);
        emit(
          AuthenticationLoaded(
              refreshToken: responseToken['refresh'],
              token: responseToken['access']),
        );
      }
    } else {
      emit(const AuthenticationError("Auth Error"));
    }

    loadingCubit.hide();
  }

  Future<void> loginUser(Map query) async {
    loadingCubit.show();

    emit(AuthenticationLoading());
    final resToken = await AuthRepo.getUserToken(query);
    if (resToken['access'] != null) {
      await Prefs.setToken(resToken['access']);
      await Prefs.setRefreshToken(resToken['refresh']);
      await Prefs.setIsNewUser(false);
      emit(
        AuthenticationLoaded(
            refreshToken: resToken['refresh'], token: resToken['access']),
      );
    } else {
      emit(const AuthenticationError("Auth Error"));
    }

    loadingCubit.hide();
  }

  Future<void> logoutUser() async {
    loadingCubit.show();

    emit(AuthenticationLoading());
    await Prefs.clearPrefs();

    loadingCubit.hide();
  }
}
