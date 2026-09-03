import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'wallet_provider.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletProvider);

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
                _showAddWalletDialog(context, ref);
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Baru'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (wallets.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('Belum ada dompet. Silakan tambah baru.'),
            ),
          ),

        for (var wallet in wallets)
          _buildWalletItem(
            context,
            wallet['nama_wallet'],
            wallet['tipe'],
            wallet['saldo_awal'] as double,
          ),
      ],
    );
  }

  void _showAddWalletDialog(BuildContext context, WidgetRef ref) {
    final namaController = TextEditingController();
    final saldoController = TextEditingController();
    String tipeSelected = 'bank';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Tambah Dompet Baru'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Dompet (Mis: BCA)',
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: tipeSelected,
                    decoration: const InputDecoration(labelText: 'Tipe'),
                    items: const [
                      DropdownMenuItem(
                        value: 'bank',
                        child: Text('Rekening Bank'),
                      ),
                      DropdownMenuItem(
                        value: 'e-wallet',
                        child: Text('E-Wallet'),
                      ),
                      DropdownMenuItem(
                        value: 'cash',
                        child: Text('Uang Tunai'),
                      ),
                    ],
                    onChanged: (val) => setState(() => tipeSelected = val!),
                  ),
                  TextField(
                    controller: saldoController,
                    decoration: const InputDecoration(labelText: 'Saldo Awal'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    final nama = namaController.text;
                    final saldo = double.tryParse(saldoController.text) ?? 0.0;
                    if (nama.isNotEmpty) {
                      ref
                          .read(walletProvider.notifier)
                          .addWallet(nama, tipeSelected, saldo);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
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
