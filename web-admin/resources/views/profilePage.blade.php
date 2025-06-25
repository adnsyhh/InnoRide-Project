<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Profile Page</title>
  <link rel="stylesheet" href="{{ asset('css/profilePage.css') }}" />
  <style>
    .profile-section {
      background: linear-gradient(to right, #000, #999);
      padding: 30px;
      border-radius: 25px;
      margin: 30px auto;
      max-width: 1000px;
      display: flex;
      gap: 40px;
      align-items: flex-start;
      justify-content: center;
      flex-wrap: wrap;
    }
    .profile-picture {
      position: relative;
      background: #eee;
      padding: 15px;
      border-radius: 25px;
      box-shadow: 4px 4px 12px rgba(0, 0, 0, 0.3);
    }
    .profile-picture img {
      width: 180px;
      height: 180px;
      border-radius: 20px;
      object-fit: cover;
    }
    .profile-details {
      background: linear-gradient(to right, #222, #444);
      padding: 20px;
      border-radius: 20px;
      color: white;
      font-size: 16px;
      width: 100%;
      max-width: 400px;
    }
    .input-field {
      width: 100%;
      padding: 8px;
      margin-top: 5px;
      margin-bottom: 15px;
      border-radius: 10px;
      border: 1px solid #ccc;
    }
    .submit-button {
      margin-top: 10px;
      padding: 10px 20px;
      background: #eee;
      color: #000;
      font-size: 16px;
      border: none;
      border-radius: 15px;
      cursor: pointer;
      box-shadow: 4px 4px 8px rgba(0, 0, 0, 0.3);
    }
  </style>
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
        <a href="{{ route('user.index') }}"><img src="{{ asset('assets/mukaino-Photoroom.png') }}" alt="user" /></a>
        <a href="{{ route('order.index') }}"><img src="{{ asset('assets/task.png') }}" alt="order" /></a>
        <a href="{{ route('vehicle.index') }}"><img src="{{ asset('assets/mobilino-Photoroom.png') }}" alt="vehicle" /></a>
        <a href="{{ route('promo.index') }}"><img src="{{ asset('assets/diskonino-Photoroom.png') }}" alt="promo" /></a>
        <a href="{{ route('chart.index') }}"><img src="{{ asset('assets/chartino-Photoroom.png') }}" alt="chart" /></a>
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
      <!-- Topbar -->
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

      <!-- Profile Section -->
      <section class="profile-section">
        <div class="profile-picture">
          <img src="{{ asset(Auth::user()->profile_picture ? 'storage/' . Auth::user()->profile_picture : 'css/cat-profile.jpg') }}" alt="User Photo" />
        </div>

        <div class="profile-details">
          @if (session('success'))
            <p style="color: lightgreen;">{{ session('success') }}</p>
          @endif

          <form action="{{ route('profile.update') }}" method="POST" enctype="multipart/form-data">
            @csrf

            <label><strong>Username:</strong></label>
            <input type="text" name="name" class="input-field" value="{{ Auth::user()->name }}" required />

            <label><strong>Email:</strong></label>
            <input type="email" name="email" class="input-field" value="{{ Auth::user()->email }}" required />

            <label><strong>Ubah Foto (opsional):</strong></label>
            <input type="file" name="profile_picture" accept="image/*" class="input-field" />

            <button type="submit" class="submit-button">Simpan</button>
          </form>
        </div>
      </section>
    </div>
  </div>
</body>
</html>
