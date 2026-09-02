class ApiConfig {
  // Base URL backend CodeIgniter 3 yang sudah di-hosting
  static const String baseUrl = 'https://finance.callusmars.com/api';

  // Endpoints
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';

  static const String syncPush = '$baseUrl/sync/push';
  static const String syncPull = '$baseUrl/sync/pull';
}
