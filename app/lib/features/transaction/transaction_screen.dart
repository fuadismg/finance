import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Transaksi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Tampilkan filter (bulan, kategori, dll)
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Ringkasan Bulan Ini
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Pemasukan', style: TextStyle(color: Colors.green)),
                      Text(
                        'Rp 5.000.000',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Pengeluaran', style: TextStyle(color: Colors.red)),
                      Text(
                        'Rp 3.500.000',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Daftar Transaksi Berdasarkan Tanggal
          const Text(
            'Hari Ini - 03 September 2026',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          _buildTransactionItem(
            context,
            'Beli Kopi',
            'Makanan & Minuman',
            -25000,
          ),
          _buildTransactionItem(context, 'Isi Bensin', 'Transportasi', -50000),

          const SizedBox(height: 16),
          const Text(
            'Kemarin - 02 September 2026',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          _buildTransactionItem(context, 'Transfer Masuk', 'Lainnya', 150000),
          _buildTransactionItem(context, 'Bayar Listrik', 'Tagihan', -250000),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Buka Form Tambah Transaksi
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    String title,
    String category,
    double amount,
  ) {
    final isIncome = amount > 0;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
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
        subtitle: Text(category),
        trailing: Text(
          '${isIncome ? '+' : ''} Rp ${amount.abs().toInt()}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
