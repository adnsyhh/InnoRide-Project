<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Promo Page</title>
    <link rel="stylesheet" href="{{ asset('css/managementPromoPage.css') }}" />
    <style>
      .promo-card {
        background-color: #fff;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        flex: 1;
        min-width: 250px;
        max-width: 350px;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
      }
      .promo-card:hover {
        transform: translateY(-10px) scale(1.05);
        box-shadow: 6px 6px 20px rgba(0, 0, 0, 0.4);
        z-index: 10;
      }

      .promo-section {
        background: linear-gradient(to right, #000, #999);
        padding: 30px;
        border-radius: 25px;
        margin-top: 20px;
      }
      .promo-section h2 {
        color: white;
        margin-bottom: 20px;
      }

      .add-promo-btn {
        display: block;
        margin: 20px 0;
        padding: 10px 20px;
        font-size: 16px;
        background-color: #fff;
        color: #000;
        border: none;
        border-radius: 10px;
        cursor: pointer;
        box-shadow: 2px 2px 5px rgba(0,0,0,0.3);
      }

      .promo-form {
        display: none;
        background: #fff;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
      }
      .promo-form input, .promo-form textarea, .promo-form select {
        width: 100%;
        margin-bottom: 10px;
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 14px;
      }
      .promo-form label {
        font-weight: bold;
        margin-top: 10px;
        display: block;
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

        <!-- Promo Content -->
        <section class="promo-section">
          <h2>Promo Hari Ini</h2>

          <button class="add-promo-btn" onclick="togglePromoForm()">+ Tambah Promo</button>

          <!-- FORM TAMBAH PROMO -->
          <form class="promo-form" id="promoForm" method="POST" action="{{ route('promo.store') }}">
            @csrf
            <label for="code">Kode Promo</label>
            <input type="text" id="code" name="code" required />

            <label for="description">Deskripsi Promo</label>
            <textarea id="description" name="description" rows="3"></textarea>

            <label for="discount_percentage">Diskon (%)</label>
            <input type="number" id="discount_percentage" name="discount_percentage" min="1" max="100" />

            <label for="valid_from">Tanggal Berlaku Dari</label>
            <input type="date" id="valid_from" name="valid_from" />

            <label for="valid_to">Tanggal Berlaku Sampai</label>
            <input type="date" id="valid_to" name="valid_to" />

            <label for="active">Status</label>
            <select id="active" name="active">
              <option value="1">Aktif</option>
              <option value="0">Tidak Aktif</option>
            </select>

            <button type="submit" class="add-promo-btn">Simpan Promo</button>
          </form>

          <!-- LIST PROMO -->
          <div class="promo-container" style="display:flex; flex-wrap:wrap; gap:20px; margin-top:20px;">
            @foreach ($promos as $promo)
              <div class="promo-card">
                <h3>{{ $promo->code }}</h3>
                <p>{{ $promo->description }}</p>
                <p>Diskon: {{ $promo->discount_percentage }}%</p>
                <p>Periode: {{ $promo->valid_from->format('d M Y') }} - {{ $promo->valid_to->format('d M Y') }}</p>
                <p>Status: {{ $promo->active ? 'Aktif' : 'Tidak Aktif' }}</p>
                <form action="{{ route('promo.destroy', $promo->id) }}" method="POST" style="margin-top:10px;">
                  @csrf
                  @method('DELETE')
                  <button type="submit" style="background:red;color:white;padding:5px 10px;border:none;border-radius:5px;">Hapus</button>
                </form>
              </div>
            @endforeach
          </div>
        </section>
      </div>
    </div>

    <script>
      function togglePromoForm() {
        const form = document.getElementById('promoForm');
        form.style.display = form.style.display === 'none' || form.style.display === '' ? 'block' : 'none';
      }
    </script>
  </body>
</html>
