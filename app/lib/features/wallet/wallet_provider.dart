import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local_db_helper.dart';

final walletProvider = StateNotifierProvider<WalletNotifier, List<Map<String, dynamic>>>((ref) {
  return WalletNotifier();
});

class WalletNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  WalletNotifier() : super([]) {
    loadWallets();
  }

  Future<void> loadWallets() async {
    final db = await LocalDbHelper.instance.database;
    // Mengambil dompet milik user, sementara userId diset statis 1, idealnya dari Auth
    // Kita abaikan user_id filter untuk offline mode agar simpel, atau fetch semua dompet aktif
    final maps = await db.query('wallets', where: 'is_active = ?', whereArgs: [1]);
    state = maps;
  }

  Future<void> addWallet(String nama, String tipe, double saldoAwal) async {
    final db = await LocalDbHelper.instance.database;
    await db.insert('wallets', {
      'user_id': 1, // TODO: Dinamis dari Auth
      'nama_wallet': nama,
      'tipe': tipe,
      'saldo_awal': saldoAwal,
      'sync_status': 'pending_insert'
    });
    await loadWallets();
  }
}
