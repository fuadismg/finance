import 'package:dio/dio.dart';
import '../../core/api_config.dart';
import '../../core/api_client.dart';
import '../../data/local_db_helper.dart';

class SyncService {
  Future<Map<String, dynamic>> syncPush() async {
    try {
      final db = await LocalDbHelper.instance.database;
      
      // Ambil data yang belum di-sync (pending_insert)
      final wallets = await db.query('wallets', where: 'sync_status = ?', whereArgs: ['pending_insert']);
      final categories = await db.query('categories', where: 'sync_status = ?', whereArgs: ['pending_insert']);
      final transactions = await db.query('transactions', where: 'sync_status = ?', whereArgs: ['pending_insert']);

      if (wallets.isEmpty && categories.isEmpty && transactions.isEmpty) {
        return {'success': true, 'message': 'Tidak ada data baru untuk di-push.'};
      }

      final payload = {
        'wallets': wallets,
        'categories': categories,
        'transactions': transactions,
      };

      final dio = await ApiClient.getClient();
      final response = await dio.post(ApiConfig.syncPush, data: payload);

      if (response.statusCode == 200 && response.data['status'] == true) {
        // Jika sukses, ubah status menjadi synced
        await db.update('wallets', {'sync_status': 'synced'}, where: 'sync_status = ?', whereArgs: ['pending_insert']);
        await db.update('categories', {'sync_status': 'synced'}, where: 'sync_status = ?', whereArgs: ['pending_insert']);
        await db.update('transactions', {'sync_status': 'synced'}, where: 'sync_status = ?', whereArgs: ['pending_insert']);
        return {'success': true, 'message': 'Push sinkronisasi berhasil!'};
      }
      return {'success': false, 'message': 'Gagal push data ke server.'};
    } on DioException catch (e) {
      return {'success': false, 'message': 'Error jaringan: ${e.message}'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> syncPull(String lastSyncTime) async {
    try {
      final dio = await ApiClient.getClient();
      final response = await dio.post(ApiConfig.syncPull, data: {'last_sync': lastSyncTime});

      if (response.statusCode == 200 && response.data['status'] == true) {
        final data = response.data['data'];
        final db = await LocalDbHelper.instance.database;
        
        // TODO: Simpan data yang ditarik dari server ke SQLite (Client Wins, abaikan konflik atau timpa jika id_server cocok)

        return {'success': true, 'message': 'Pull sinkronisasi berhasil!'};
      }
      return {'success': false, 'message': 'Gagal pull data.'};
    } on DioException catch (e) {
      return {'success': false, 'message': 'Error jaringan: ${e.message}'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
