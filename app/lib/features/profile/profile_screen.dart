import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_provider.dart';
import '../sync/sync_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 24),
        const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
        const SizedBox(height: 16),
        const Text(
          'Nama Pengguna',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text(
          'email@example.com',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 32),

        ListTile(
          leading: const Icon(Icons.category),
          title: const Text('Kelola Kategori'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Buka halaman manajemen kategori
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Sinkronisasi Data (Push)'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            final syncService = SyncService();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Menyinkronkan data...')),
            );
            final result = await syncService.syncPush();
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(result['message'])));
            }
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.download),
          title: const Text('Tarik Data (Pull)'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Panggil fungsi sync pull
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            'Keluar (Logout)',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () async {
            // Konfirmasi sebelum logout
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Konfirmasi'),
                content: const Text('Apakah Anda yakin ingin keluar?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Keluar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              ref.read(authStateProvider.notifier).logout();
            }
          },
        ),
      ],
    );
  }
}
