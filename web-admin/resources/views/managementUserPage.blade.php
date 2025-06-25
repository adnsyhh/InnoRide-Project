<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>User Management</title>
  <link rel="stylesheet" href="{{ asset('css/managementUserPage.css') }}" />
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

      <!-- User Management -->
      <div class="user-management-wrapper">
        <div class="user-table">
          <div class="table-scroll-wrapper">
            <table>
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Password</th>
                  <th>Role</th>
                  <th>Username</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                @foreach($users as $user)
                <tr>
                  <td><div class="cell">{{ $user->name }}</div></td>
                  <td><div class="cell">{{ $user->email }}</div></td>
                  <td><div class="cell">••••••</div></td>
                  <td><div class="cell">{{ ucfirst($user->role) }}</div></td>
                  <td><div class="cell">{{ $user->username }}</div></td>
                  <td>
                    <form method="POST" action="{{ route('user.updateStatus', $user->id) }}">
                        @csrf
                        @method('PATCH')
                        <select name="user_sts" class="status-dropdown" onchange="this.form.submit()">
                        <option value="active" {{ $user->user_sts == 'active' ? 'selected' : '' }}>Active</option>
                        <option value="inactive" {{ $user->user_sts == 'inactive' ? 'selected' : '' }}>Inactive</option>
                        </select>
                    </form>
                    </td>
                </tr>
                @endforeach
              </tbody>
            </table>
          </div>
        </div>
      </div>

    </div>
  </div>

  <!-- Script untuk update warna dropdown -->
  <script>
    function updateStatusColor(select) {
      select.classList.remove('status-active', 'status-inactive');
      if (select.value === 'active') {
        select.classList.add('status-active');
      } else if (select.value === 'inactive') {
        select.classList.add('status-inactive');
      }
    }

    document.addEventListener('DOMContentLoaded', function () {
      document.querySelectorAll('.status-dropdown').forEach(function (select) {
        updateStatusColor(select);
        select.addEventListener('change', function () {
          updateStatusColor(this);
        });
      });
    });
  </script>
</body>
</html>
