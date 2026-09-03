import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../wallet/wallet_provider.dart';
import '../transaction/transaction_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletProvider);
    final transactions = ref.watch(transactionProvider);

    double totalSaldo = 0;
    for (var w in wallets) {
      totalSaldo += (w['saldo_awal'] as num).toDouble(); // Sementara ambil saldo_awal, idealnya dihitung dengan transaksi
    }

    // Ambil maksimal 3 transaksi terakhir
    final recentTransactions = transactions.take(3).toList();

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Saldo Utama Card
        Card(
          elevation: 2,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Saldo (Semua Dompet)',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${totalSaldo.toInt()}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Quick Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildQuickAction(
              context,
              Icons.arrow_upward,
              'Pemasukan',
              Colors.green,
            ),
            _buildQuickAction(
              context,
              Icons.arrow_downward,
              'Pengeluaran',
              Colors.red,
            ),
            _buildQuickAction(context, Icons.sync, 'Sinkronisasi', Colors.blue),
          ],
        ),
        const SizedBox(height: 32),

        // Transaksi Terakhir
        const Text(
          'Transaksi Terakhir',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        if (recentTransactions.isEmpty) const Text('Belum ada transaksi.'),

        for (var tx in recentTransactions)
          _buildTransactionItem(
            context,
            tx['catatan'] ?? 'Tanpa Catatan',
            'Kategori ${tx['category_id']}',
            (tx['jumlah'] as num).toDouble(),
            tx['tipe'] == 'pemasukan',
            tx['tanggal'].toString().substring(0, 10),
          ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color.withOpacity(0.1),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: () {
              // TODO: Aksi cepat
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    String title,
    String category,
    double amount,
    bool isIncome,
    String date,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome
              ? Colors.green.withOpacity(0.2)
              : Colors.red.withOpacity(0.2),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$category • $date'),
        trailing: Text(
          '${isIncome ? '+' : ''} Rp ${amount.toInt()}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
