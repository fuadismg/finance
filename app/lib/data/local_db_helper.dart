import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDbHelper {
  static final LocalDbHelper instance = LocalDbHelper._init();
  static Database? _database;

  LocalDbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dompet_digital.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Tabel Wallets
    await db.execute('''
      CREATE TABLE wallets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_server INTEGER,
        user_id INTEGER NOT NULL,
        nama_wallet TEXT NOT NULL,
        tipe TEXT NOT NULL,
        saldo_awal REAL DEFAULT 0.0,
        is_active INTEGER DEFAULT 1,
        sync_status TEXT DEFAULT 'pending_insert'
      )
    ''');

    // Tabel Categories
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_server INTEGER,
        user_id INTEGER,
        nama_kategori TEXT NOT NULL,
        tipe TEXT NOT NULL,
        icon TEXT,
        is_active INTEGER DEFAULT 1,
        sync_status TEXT DEFAULT 'pending_insert'
      )
    ''');

    // Tabel Transactions
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_server INTEGER,
        user_id INTEGER NOT NULL,
        wallet_id INTEGER NOT NULL,
        category_id INTEGER NOT NULL,
        jumlah REAL NOT NULL,
        tipe TEXT NOT NULL,
        tanggal TEXT NOT NULL,
        catatan TEXT,
        sync_status TEXT DEFAULT 'pending_insert'
      )
    ''');

    // Insert Default System Categories (as id_server placeholders)
    // Note: In a real app, you might sync these from the backend instead of hardcoding.
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
