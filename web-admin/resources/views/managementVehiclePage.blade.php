<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Vehicle Page</title>
    <link rel="stylesheet" href="{{ asset('css/managementVehiclePage.css') }}" />
    <meta name="csrf-token" content="{{ csrf_token() }}">
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
        <!-- Topbar -->
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

        <!-- Vehicle Table -->
        <section class="content">
          <div class="vehicle-list">
            <div class="vehicle-header">
              <span></span>
              <span>Name</span>
              <span>Type</span>
              <span>Price / day</span>
              <span>Availability</span>
              <span></span>
            </div>

            @foreach ($vehicles as $vehicle)
              <div class="vehicle-row" data-id="{{ $vehicle->id }}">
                <button class="delete-btn">−</button>
                <span>{{ $vehicle->name }}</span>
                <span>{{ $vehicle->type }}</span>
                <span>Rp{{ $vehicle->price_per_day }}</span>
                <span>{{ $vehicle->availability ? 'Available' : 'Rented' }}</span>
                <button class="edit-btn">Edit</button>
              </div>
            @endforeach
          </div>
          <button class="add-btn">Tambah</button>
        </section>
      </main>
    </div>

    <!-- Modal for Vehicle Form -->
    <div class="modal" id="vehicleModal">
      <div class="modal-content">
        <h3 id="modalTitle">Tambah Kendaraan</h3>
        <form id="vehicleForm" method="POST" enctype="multipart/form-data">
          @csrf
          <div id="methodField"></div>
          <input name="name" placeholder="Name" required />
          <input name="type" placeholder="Type" required />
          <input name="price_per_day" placeholder="Harga per hari (Rp)" type="number" required />
          <select name="availability" required>
            <option value="1">Available</option>
            <option value="0">Rented</option>
          </select>
          <textarea name="description" placeholder="Description"></textarea>
          <input name="image" type="file" accept="image/*" />
          <input name="seat" placeholder="Seat Capacity" type="number" />
          <select name="transmission">
            <option value="Manual">Manual</option>
            <option value="Automatic">Automatic</option>
          </select>
          <input name="door" placeholder="Door Count" type="number" />
          <select name="category">
            <option value="Sedan">Sedan</option>
            <option value="SUV">SUV</option>
            <option value="Sports">Sports</option>
            <option value="Motor">Motor</option>
          </select>

          <div style="display: flex; justify-content: space-between; gap: 10px">
            <button type="button" onclick="closeModal()" style="background-color: #888">Batal</button>
            <button type="submit">Simpan</button>
          </div>
        </form>
      </div>
    </div>

    <script>
      const modal = document.getElementById("vehicleModal");
      const modalTitle = document.getElementById("modalTitle");
      const form = document.getElementById("vehicleForm");
      const methodField = document.getElementById("methodField");

      function closeModal() {
        modal.style.display = "none";
        form.reset();
        methodField.innerHTML = '';
      }

      function openVehicleModal(row = null) {
        if (row) {
          // Edit mode
          const id = row.getAttribute("data-id");
          modalTitle.textContent = "Edit Kendaraan";
          form.action = `/vehicle/${id}`;
          methodField.innerHTML = '<input type="hidden" name="_method" value="PUT">';

          const spans = row.querySelectorAll("span");
          form.name.value = spans[0].textContent;
          form.type.value = spans[1].textContent;
          form.price_per_day.value = spans[2].textContent.replace("Rp", "").replace(/\D/g, "");
          form.availability.value = spans[3].textContent;
        } else {
          // Tambah mode
          modalTitle.textContent = "Tambah Kendaraan";
          form.action = `{{ route('vehicle.store') }}`;
          methodField.innerHTML = '';
          form.reset();
        }
        modal.style.display = "flex";
      }

      document.addEventListener("DOMContentLoaded", () => {
        document.querySelectorAll(".edit-btn").forEach((btn) => {
          btn.addEventListener("click", () => openVehicleModal(btn.parentElement));
        });

        document.querySelectorAll(".delete-btn").forEach((btn) => {
          btn.addEventListener("click", () => btn.parentElement.remove());
        });

        document.querySelector(".add-btn").addEventListener("click", () => openVehicleModal(null));
      });
    </script>
  </body>
</html>
