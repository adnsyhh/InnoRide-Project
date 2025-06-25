<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Notifications\DatabaseNotification;

class NotificationController extends Controller
{
    public function index()
    {
        $notifications = Auth::user()->notifications; // atau `->unreadNotifications` jika hanya yang belum dibaca
        return view('notificationPage', compact('notifications'));
    }
}
