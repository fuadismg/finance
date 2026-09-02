<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class M_Wallets extends CI_Model {

    public function __construct()
    {
        parent::__construct();
    }

    public function get_wallets_by_user($user_id)
    {
        $this->db->where('user_id', $user_id);
        return $this->db->get('wallets')->result();
    }

    public function insert_wallet($data)
    {
        $this->db->insert('wallets', $data);
        return $this->db->insert_id();
    }

    public function update_wallet($id, $user_id, $data)
    {
        $this->db->where('id', $id);
        $this->db->where('user_id', $user_id);
        return $this->db->update('wallets', $data);
    }
}

