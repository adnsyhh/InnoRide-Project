<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    // Tampilkan form login (GET /login)
    public function showLoginForm()
    {
        return view('signInPage'); // pastikan file ada di resources/views/
    }

    // Proses login (POST /login)
    public function login(Request $request)
    {
        $credentials = $request->only('email', 'password');

        if (Auth::attempt($credentials, $request->filled('remember'))) {
            $request->session()->regenerate();

            // Cek role admin
            if (Auth::user()->role === 'admin') {
                return redirect()->intended('/home'); // atau ke /dashboard admin
            } else {
                Auth::logout();
                return back()->withErrors([
                    'email' => 'Akun Anda tidak memiliki akses ke halaman admin.',
                ]);
            }
        }

        return back()->withErrors([
            'email' => 'Login gagal. Cek kembali email atau password Anda.',
        ])->withInput();
    }

    // Logout
    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        return redirect('/login');
    }
}
