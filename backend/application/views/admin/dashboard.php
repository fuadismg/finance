                <h2>Dashboard</h2>
                <p class="text-muted">Selamat datang di Panel Admin Dompet Digital.</p>

                <div class="row mt-4">
                    <!-- Stat Card: Total Users -->
                    <div class="col-md-4 mb-3">
                        <div class="card text-white bg-primary shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">Total Pengguna</h5>
                                <h2><?= $total_users ?></h2>
                            </div>
                        </div>
                    </div>
                    <!-- Stat Card: Total Wallets -->
                    <div class="col-md-4 mb-3">
                        <div class="card text-white bg-success shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">Total Dompet Dibuat</h5>
                                <h2><?= $total_wallets ?></h2>
                            </div>
                        </div>
                    </div>
                    <!-- Stat Card: Total Transactions -->
                    <div class="col-md-4 mb-3">
                        <div class="card text-white bg-warning shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">Total Transaksi</h5>
                                <h2><?= $total_transactions ?></h2>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card mt-4 shadow-sm">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">Transaksi Terbaru (Seluruh Sistem)</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Tanggal</th>
                                        <th>Pengguna</th>
                                        <th>Kategori</th>
                                        <th>Tipe</th>
                                        <th>Jumlah (Rp)</th>
                                        <th>Catatan</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php if(empty($recent_transactions)): ?>
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-3">Belum ada transaksi.</td>
                                    </tr>
                                    <?php else: ?>
                                        <?php foreach($recent_transactions as $trx): ?>
                                        <tr>
                                            <td><?= $trx->tanggal ?></td>
                                            <td><?= $trx->nama_user ?></td>
                                            <td><?= $trx->nama_kategori ?? '-' ?></td>
                                            <td>
                                                <?php if($trx->tipe == 'pemasukan'): ?>
                                                    <span class="badge bg-success">Pemasukan</span>
                                                <?php else: ?>
                                                    <span class="badge bg-danger">Pengeluaran</span>
                                                <?php endif; ?>
                                            </td>
                                            <td><?= number_format($trx->jumlah, 0, ',', '.') ?></td>
                                            <td><?= $trx->catatan ?></td>
                                        </tr>
                                        <?php endforeach; ?>
                                    <?php endif; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

