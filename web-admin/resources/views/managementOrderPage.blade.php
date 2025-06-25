<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Order Management</title>
    <link rel="stylesheet" href="{{ asset('css/managementOrderPage.css') }}" />
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
      <main class="main">
        <header class="topbar">
          <div class="search-container">
            <input type="text" class="search-bar" placeholder="Search..." />
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
        </header>

        <section class="order-container">
          <div class="order-header">
            <div>User ID</div>
            <div>Vehicle ID</div>
            <div>Start Date</div>
            <div>End Date</div>
            <div>Total Price</div>
            <div>Status</div>
          </div>

          @foreach ($bookings as $booking)
          <div class="order-row">
            <div class="order-cell">{{ $booking->user_id }}</div>
            <div class="order-cell">{{ $booking->vehicle_id }}</div>
            <div class="order-cell">{{ $booking->start_date->format('Y-m-d') }}</div>
            <div class="order-cell">{{ $booking->end_date->format('Y-m-d') }}</div>
            <div class="order-cell">Rp{{ number_format($booking->total_price, 0, ',', '.') }}</div>
            <div class="order-cell">
              <form method="POST" action="{{ route('order.updateStatus', $booking->id) }}">
                @csrf
                @method('PATCH')
                <select name="status" class="status-dropdown" onchange="this.form.submit()">
                  <option value="pending"  {{ $booking->status === 'pending' ? 'selected' : '' }}>Pending</option>
                  <option value="confirmed"  {{ $booking->status === 'confirmed' ? 'selected' : '' }}>Confirm</option>
                  <option value="selesai"   {{ $booking->status === 'selesai' ? 'selected' : '' }}>Finish</option>
                  <option value="dibatalkan"   {{ $booking->status === 'dibatalkan' ? 'selected' : '' }}>Cancel</option>
                </select>
              </form>
            </div>
          </div>
          @endforeach
        </section>
      </main>
    </div>
  </body>
</html>
