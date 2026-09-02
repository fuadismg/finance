import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_config.dart';
import '../../core/api_client.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final dio = await ApiClient.getClient();
      final response = await dio.post(
        ApiConfig.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        final token = response.data['data']['token'];

        // Simpan token ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        return {'success': true, 'message': response.data['message']};
      }
      return {'success': false, 'message': 'Gagal login.'};
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Error dari server',
        };
      }
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    }
  }

  Future<Map<String, dynamic>> register(
    String nama,
    String email,
    String password,
  ) async {
    try {
      final dio = await ApiClient.getClient();
      final response = await dio.post(
        ApiConfig.register,
        data: {'nama': nama, 'email': email, 'password': password},
      );

      if (response.statusCode == 201 && response.data['status'] == true) {
        return {'success': true, 'message': response.data['message']};
      }
      return {'success': false, 'message': 'Gagal registrasi.'};
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Error dari server',
        };
      }
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return token != null && token.isNotEmpty;
  }
}
