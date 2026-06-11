<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\Admin;
use Illuminate\Support\Facades\Auth;
use Laravel\Socialite\Facades\Socialite;

class GoogleController extends Controller
{
    public function redirect()
    {
        return Socialite::driver('google')->with(['prompt' => 'select_account'])->redirect();
    }

    public function callback()
    {
        try {
            $googleUser = Socialite::driver('google')->user();
        } catch (\Exception $e) {
            return redirect('/admin/login')->withErrors(['email' => 'Login Google gagal, coba lagi.']);
        }

        $admin = Admin::where('google_id', $googleUser->getId())
            ->orWhere('email', $googleUser->getEmail())
            ->first();

        if (!$admin) {
            return redirect('/admin/login')->withErrors(['email' => 'Akun Google ini tidak terdaftar sebagai admin.']);
        }

        if (!$admin->google_id) {
            $admin->update(['google_id' => $googleUser->getId()]);
        }

        Auth::guard('admin')->login($admin, true);

        return redirect('/admin');
    }
}
