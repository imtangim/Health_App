import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/Auth/repo/authrepo.dart';
import 'package:health_app/extra/snackbar.dart';
import 'package:health_app/model/usermodel.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);
final authControlerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authcontroller = ref.watch(authControlerProvider.notifier);

  return authcontroller.authStateChange;
});

final getuserDataProvider = StreamProvider.family((ref, String uid) {
  final authcontroller = ref.watch(authControlerProvider.notifier);
  return authcontroller.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepo _authRepository;
  final Ref _ref;

  AuthController({required AuthRepo authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l) => showSnackbar(context, l.message),
      (usermodel) =>
          _ref.read(userProvider.notifier).update((state) => usermodel),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logout() async {
    _authRepository.logout();
  }
}
