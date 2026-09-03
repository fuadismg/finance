import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transaction_provider.dart';
import '../wallet/wallet_provider.dart';

class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    
    // Hitung ringkasan
    double totalPemasukan = 0;
    double totalPengeluaran = 0;
    for (var tx in transactions) {
      if (tx['tipe'] == 'pemasukan') totalPemasukan += (tx['jumlah'] as num).toDouble();
      if (tx['tipe'] == 'pengeluaran') totalPengeluaran += (tx['jumlah'] as num).toDouble();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Transaksi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Ringkasan
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('Pemasukan', style: TextStyle(color: Colors.green)),
                      Text('Rp ${totalPemasukan.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Pengeluaran', style: TextStyle(color: Colors.red)),
                      Text('Rp ${totalPengeluaran.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          if (transactions.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('Belum ada transaksi. Tambahkan sekarang!'),
            )),

          for (var tx in transactions)
            _buildTransactionItem(
              context, 
              tx['catatan'] ?? 'Tanpa Catatan', 
              'Kategori ${tx['category_id']}', // Sementara ID
              (tx['jumlah'] as num).toDouble(),
              tx['tipe'] == 'pemasukan',
              tx['tanggal'].toString().substring(0, 10)
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTransactionDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context, WidgetRef ref) {
    final wallets = ref.read(walletProvider);
    if (wallets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap tambahkan dompet terlebih dahulu!')),
      );
      return;
    }

    final catatanController = TextEditingController();
    final jumlahController = TextEditingController();
    String tipeSelected = 'pengeluaran';
    int? walletIdSelected = wallets.first['id'];
    int categoryIdSelected = 1; // Default kategori sementara

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Tambah Transaksi'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: tipeSelected,
                    decoration: const InputDecoration(labelText: 'Tipe'),
                    items: const [
                      DropdownMenuItem(value: 'pengeluaran', child: Text('Pengeluaran')),
                      DropdownMenuItem(value: 'pemasukan', child: Text('Pemasukan')),
                    ],
                    onChanged: (val) => setState(() => tipeSelected = val!),
                  ),
                  DropdownButtonFormField<int>(
                    value: walletIdSelected,
                    decoration: const InputDecoration(labelText: 'Pilih Dompet'),
                    items: wallets.map((w) {
                      return DropdownMenuItem<int>(
                        value: w['id'],
                        child: Text(w['nama_wallet']),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => walletIdSelected = val),
                  ),
                  TextField(
                    controller: jumlahController,
                    decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: catatanController,
                    decoration: const InputDecoration(labelText: 'Catatan'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () {
                  final catatan = catatanController.text;
                  final jumlah = double.tryParse(jumlahController.text) ?? 0.0;
                  if (jumlah > 0 && walletIdSelected != null) {
                    ref.read(transactionProvider.notifier).addTransaction(
                      walletIdSelected!, 
                      categoryIdSelected, 
                      jumlah, 
                      tipeSelected, 
                      catatan
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildTransactionItem(BuildContext context, String title, String category, double amount, bool isIncome, String date) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
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
