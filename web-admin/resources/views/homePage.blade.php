<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard</title>
    <link rel="stylesheet" href="{{ asset('css/homePage.css') }}" />
  </head>
  <body>
    <div class="container">
      <!-- Sidebar -->
      <div class="sidebar">
        <div class="logo">
            <a href="{{ route('home') }}">
                <img src="{{ asset('assets/logo.png') }}" alt="Logo" />
            </a>
        </div>
        <div class="menu-icons">
          <a href="{{ route('user.index') }}">
            <img src="{{ asset('assets/mukaino-Photoroom.png') }}" alt="user" />
          </a>
          <a href="{{ route('order.index') }}">
            <img src="{{ asset('assets/task.png') }}" alt="order" />
          </a>
          <a href="{{ route('vehicle.index') }}">
            <img src="{{ asset('assets/mobilino-Photoroom.png') }}" alt="vehicle" />
          </a>
          <a href="{{ route('promo.index') }}">
            <img src="{{ asset('assets/diskonino-Photoroom.png') }}" alt="promo" />
          </a>
          <a href="{{ route('chart.index') }}">
            <img src="{{ asset('assets/chartino-Photoroom.png') }}" alt="chart" />
          </a>
          <form action="{{ route('logout') }}" method="POST">
            @csrf
            <button style="background:none;border:none;padding:0;">
              <img src="{{ asset('assets/Logout.png') }}" alt="logout" />
            </button>
          </form>
        </div>
      </div>

      <!-- Main Content -->
      <div class="main">
        <div class="topbar">
          <div class="search-bar">
            <input type="text" placeholder="Search..." />
          </div>
          <div class="user-info">
            <a href="{{ route('notification.index') }}">
              <img src="{{ asset('assets/notification.png') }}" alt="notification" class="notification-icon" />
            </a>
            <a href="{{ route('profile.index') }}" style="display: flex; align-items: center; gap: 10px; text-decoration: none; color: inherit;">
              <!-- <img
                src="{{ asset('assets/notification.png') }}"
                alt="Notification"
                class="notification-icon"
              /> -->
              <img
                src="{{ asset('assets/profile icon.png') }}"
                alt="Profile"
                class="profile-icon"
              />
              <span>{{ Auth::user()->name }}</span>
            </a>
          </div>
        </div>

        <div class="dashboard-wrapper" style="background: linear-gradient(to right, #000, #999); padding: 30px; border-radius: 20px; margin-top: 20px;">
          <div class="status-boxes" style="display: flex; gap: 20px; justify-content: space-between; margin-bottom: 30px;">
            <div class="box" style="background: #eee; padding: 20px; border-radius: 10px; flex: 1;">Total Confirm :<br /><strong>{{ $total_confirm }}</strong></div>
            <div class="box" style="background: #eee; padding: 20px; border-radius: 10px; flex: 1;">Total Pending :<br /><strong>{{ $total_pending }}</strong></div>
            <div class="box" style="background: #eee; padding: 20px; border-radius: 10px; flex: 1;">Total Finish :<br /><strong>{{ $total_finish }}</strong></div>
            <div class="box" style="background: #eee; padding: 20px; border-radius: 10px; flex: 1;">Total Cancel :<br /><strong>{{ $total_cancel }}</strong></div>
          </div>

          <div class="booking-box" style="background: #eee; padding: 20px; border-radius: 20px;">
            <h3 style="margin-bottom: 15px;">Booking Pending</h3>
            @foreach ($pending_bookings as $booking)
              <div style="background: white; padding: 10px 20px; margin-bottom: 10px; border-radius: 10px;">
                <strong>{{ $booking->user->name ?? 'User' }}</strong> memesan <strong>{{ $booking->vehicle->name ?? 'Kendaraan' }}</strong> pada {{ \Carbon\Carbon::parse($booking->created_at)->translatedFormat('d M Y H:i') }}
              </div>
            @endforeach
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
