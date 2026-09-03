import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Dompet & Rekening',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: Tambah Dompet
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Baru'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Placeholder Daftar Dompet
        _buildWalletItem(context, 'Uang Tunai', 'cash', 500000),
        _buildWalletItem(context, 'Rekening BCA', 'bank', 3500000),
        _buildWalletItem(context, 'GoPay', 'e-wallet', 1250000),
      ],
    );
  }

  Widget _buildWalletItem(
    BuildContext context,
    String nama,
    String tipe,
    double saldo,
  ) {
    IconData icon;
    if (tipe == 'cash')
      icon = Icons.money;
    else if (tipe == 'bank')
      icon = Icons.account_balance;
    else
      icon = Icons.account_balance_wallet;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        title: Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(tipe.toUpperCase()),
        trailing: Text(
          'Rp ${saldo.toInt()}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
