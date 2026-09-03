import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Saldo Utama Card
        Card(
          elevation: 2,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Saldo', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text(
                  'Rp 5.250.000',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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

        // Placeholder Transaksi (Nantinya diambil dari SQLite)
        _buildTransactionItem(
          context,
          'Makan Siang',
          'Makanan & Minuman',
          -35000,
          'Hari ini',
        ),
        _buildTransactionItem(
          context,
          'Gaji Bulanan',
          'Gaji',
          5000000,
          'Kemarin',
        ),
        _buildTransactionItem(
          context,
          'Bensin',
          'Transportasi',
          -50000,
          '2 hari lalu',
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
              // TODO: Action
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
    String date,
  ) {
    final isIncome = amount > 0;
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
