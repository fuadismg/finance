<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class M_Categories extends CI_Model {

    public function __construct()
    {
        parent::__construct();
    }

    public function get_categories($user_id)
    {
        // Get system default categories + user custom categories
        $this->db->where('user_id', NULL);
        $this->db->or_where('user_id', $user_id);
        return $this->db->get('categories')->result();
    }

    public function insert_category($data)
    {
        $this->db->insert('categories', $data);
        return $this->db->insert_id();
    }

    public function update_category($id, $user_id, $data)
    {
        $this->db->where('id', $id);
        $this->db->where('user_id', $user_id); // Ensure user can only edit their own
        return $this->db->update('categories', $data);
    }
}

