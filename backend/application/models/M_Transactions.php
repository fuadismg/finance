<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class M_Transactions extends CI_Model {

    public function __construct()
    {
        parent::__construct();
    }

    public function get_transactions_by_user($user_id)
    {
        $this->db->where('user_id', $user_id);
        $this->db->order_by('tanggal', 'DESC');
        return $this->db->get('transactions')->result();
    }

    public function insert_transaction($data)
    {
        $this->db->insert('transactions', $data);
        return $this->db->insert_id();
    }

    public function update_transaction($id, $user_id, $data)
    {
        $this->db->where('id', $id);
        $this->db->where('user_id', $user_id);
        return $this->db->update('transactions', $data);
    }

    public function delete_transaction($id, $user_id)
    {
        $this->db->where('id', $id);
        $this->db->where('user_id', $user_id);
        return $this->db->delete('transactions');
    }
}

