import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

class AuthNotifier extends StateNotifier<bool> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(false) {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    state = await _authService.isLoggedIn();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await _authService.login(email, password);
    if (result['success']) {
      state = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> register(
    String nama,
    String email,
    String password,
  ) async {
    return await _authService.register(nama, email, password);
  }

  Future<void> logout() async {
    await _authService.logout();
    state = false;
  }
}
