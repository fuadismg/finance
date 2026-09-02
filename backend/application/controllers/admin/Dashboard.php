<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Dashboard extends CI_Controller {

    public function __construct()
    {
        parent::__construct();
        // Load URL dan database helper/library
        $this->load->helper('url');
        $this->load->database();
        // TODO: Tambahkan library Session dan Auth Check nanti untuk keamanan
    }

    public function index()
    {
        // Mengambil statistik sederhana
        $data['total_users'] = $this->db->count_all('users');
        $data['total_transactions'] = $this->db->count_all('transactions');
        $data['total_wallets'] = $this->db->count_all('wallets');

        // Mengambil 5 transaksi terakhir untuk ditampilkan
        $this->db->select('transactions.*, users.nama as nama_user, categories.nama_kategori');
        $this->db->from('transactions');
        $this->db->join('users', 'users.id = transactions.user_id', 'left');
        $this->db->join('categories', 'categories.id = transactions.category_id', 'left');
        $this->db->order_by('transactions.created_at', 'DESC');
        $this->db->limit(5);
        $data['recent_transactions'] = $this->db->get()->result();

        // Load View
        $this->load->view('admin/header', $data);
        $this->load->view('admin/dashboard', $data);
        $this->load->view('admin/footer');
    }
}

