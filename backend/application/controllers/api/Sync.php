<?php
defined('BASEPATH') OR exit('No direct script access allowed');

use chriskacerguis\RestServer\RestController;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class Sync extends RestController {

    private $jwt_key = 'RAHASIA_DOMPET_DIGITAL_123!';
    private $jwt_algo = 'HS256';

    public function __construct()
    {
        parent::__construct();
        $this->load->model('M_Wallets');
        $this->load->model('M_Categories');
        $this->load->model('M_Transactions');
    }

    private function verify_token()
    {
        $headers = $this->input->get_request_header('Authorization');
        if (!empty($headers)) {
            if (preg_match('/Bearer\s(\S+)/', $headers, $matches)) {
                $token = $matches[1];
                try {
                    $decoded = JWT::decode($token, new Key($this->jwt_key, $this->jwt_algo));
                    return $decoded;
                } catch (Exception $e) {
                    $this->response(['status' => FALSE, 'message' => 'Token tidak valid atau kadaluarsa.'], RestController::HTTP_UNAUTHORIZED);
                    exit();
                }
            }
        }
        $this->response(['status' => FALSE, 'message' => 'Token otorisasi tidak ditemukan.'], RestController::HTTP_UNAUTHORIZED);
        exit();
    }

    // Mengambil seluruh data dari server (Pull)
    public function pull_get()
    {
        $user = $this->verify_token();
        $user_id = $user->user_id;

        $wallets = $this->M_Wallets->get_wallets_by_user($user_id);
        $categories = $this->M_Categories->get_categories($user_id);
        $transactions = $this->M_Transactions->get_transactions_by_user($user_id);

        $this->response([
            'status' => TRUE,
            'data' => [
                'wallets' => $wallets,
                'categories' => $categories,
                'transactions' => $transactions
            ]
        ], RestController::HTTP_OK);
    }

    // Mengirim data lokal ke server (Push) - Pendekatan Client Wins
    public function push_post()
    {
        $user = $this->verify_token();
        $user_id = $user->user_id;

        // Ambil payload JSON
        $wallets = $this->post('wallets') ?? [];
        $categories = $this->post('categories') ?? [];
        $transactions = $this->post('transactions') ?? [];

        $this->db->trans_start(); // Mulai transaksi DB

        // Contoh sederhana sinkronisasi "Client Wins" (Bisa dimodifikasi jika ada ID yang auto-increment)
        // Jika data dari client belum punya ID (baru), maka Insert. Jika sudah punya, maka Update.
        
        // --- TRANSAKSI ---
        foreach ($transactions as $trx) {
            $data = [
                'user_id' => $user_id,
                'wallet_id' => $trx['wallet_id'],
                'category_id' => $trx['category_id'],
                'jumlah' => $trx['jumlah'],
                'tipe' => $trx['tipe'],
                'tanggal' => $trx['tanggal'],
                'catatan' => $trx['catatan'] ?? ''
            ];

            // Jika ada field 'id_server' (artinya sudah pernah disinkron), kita update
            if (!empty($trx['id_server'])) {
                $this->M_Transactions->update_transaction($trx['id_server'], $user_id, $data);
            } else {
                $this->M_Transactions->insert_transaction($data);
            }
        }

        // TODO: Lakukan hal serupa untuk Wallets dan Categories

        $this->db->trans_complete();

        if ($this->db->trans_status() === FALSE) {
            $this->response(['status' => FALSE, 'message' => 'Gagal melakukan sinkronisasi data.'], RestController::HTTP_INTERNAL_SERVER_ERROR);
        } else {
            $this->response(['status' => TRUE, 'message' => 'Data berhasil disinkronisasi ke server.'], RestController::HTTP_OK);
        }
    }
}

