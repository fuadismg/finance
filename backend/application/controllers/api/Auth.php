<?php
defined('BASEPATH') OR exit('No direct script access allowed');

use chriskacerguis\RestServer\RestController;
use Firebase\JWT\JWT;

class Auth extends RestController {

    private $jwt_key = 'RAHASIA_DOMPET_DIGITAL_123_SUPER_AMAN_32_CHARS_MINIMUM';
    private $jwt_algo = 'HS256';

    public function __construct()
    {
        parent::__construct();
        $this->load->model('M_Users');
    }

    public function register_post()
    {
        $nama = $this->post('nama');
        $email = $this->post('email');
        $password = $this->post('password');

        if (empty($nama) || empty($email) || empty($password)) {
            $this->response([
                'status' => FALSE,
                'message' => 'Harap isi nama, email, dan password.'
            ], RestController::HTTP_BAD_REQUEST);
            return;
        }

        // Cek email sudah ada atau belum
        if ($this->M_Users->get_user_by_email($email)) {
            $this->response([
                'status' => FALSE,
                'message' => 'Email sudah terdaftar.'
            ], RestController::HTTP_CONFLICT);
            return;
        }

        $data = [
            'nama' => $nama,
            'email' => $email,
            'password_hash' => password_hash($password, PASSWORD_BCRYPT)
        ];

        if ($this->M_Users->insert_user($data)) {
            $this->response([
                'status' => TRUE,
                'message' => 'Registrasi berhasil. Silakan login.'
            ], RestController::HTTP_CREATED);
        } else {
            $this->response([
                'status' => FALSE,
                'message' => 'Gagal mendaftarkan user.'
            ], RestController::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    public function login_post()
    {
        $email = $this->post('email');
        $password = $this->post('password');

        if (empty($email) || empty($password)) {
            $this->response([
                'status' => FALSE,
                'message' => 'Email dan password tidak boleh kosong.'
            ], RestController::HTTP_BAD_REQUEST);
            return;
        }

        $user = $this->M_Users->get_user_by_email($email);

        if ($user && password_verify($password, $user->password_hash)) {
            
            $payload = [
                'iat' => time(),
                'exp' => time() + (86400 * 30), // Token berlaku 30 hari
                'user_id' => $user->id,
                'email' => $user->email,
                'nama' => $user->nama
            ];

            $token = JWT::encode($payload, $this->jwt_key, $this->jwt_algo);

            $this->response([
                'status' => TRUE,
                'message' => 'Login berhasil.',
                'data' => [
                    'token' => $token,
                    'user' => [
                        'id' => $user->id,
                        'nama' => $user->nama,
                        'email' => $user->email
                    ]
                ]
            ], RestController::HTTP_OK);
        } else {
            $this->response([
                'status' => FALSE,
                'message' => 'Email atau password salah.'
            ], RestController::HTTP_UNAUTHORIZED);
        }
    }
}

