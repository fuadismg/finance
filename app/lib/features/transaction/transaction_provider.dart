import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local_db_helper.dart';

import 'package:intl/intl.dart';

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<Map<String, dynamic>>>((
      ref,
    ) {
      return TransactionNotifier();
    });

class TransactionNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  TransactionNotifier() : super([]) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final db = await LocalDbHelper.instance.database;
    // Mengambil transaksi urut berdasarkan tanggal terbaru
    final maps = await db.query('transactions', orderBy: 'tanggal DESC');
    state = maps;
  }

  Future<void> addTransaction(
    int walletId,
    int categoryId,
    double amount,
    String type,
    String note,
  ) async {
    final db = await LocalDbHelper.instance.database;
    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    await db.insert('transactions', {
      'user_id': 1, // TODO: Dinamis dari Auth
      'wallet_id': walletId,
      'category_id': categoryId,
      'jumlah': amount,
      'tipe': type,
      'tanggal': dateStr,
      'catatan': note,
      'sync_status': 'pending_insert',
    });
    await loadTransactions();
  }
}
