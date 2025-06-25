<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Analytics Page</title>
    <link rel="stylesheet" href="{{ asset('css/analyticPage.css') }}" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  </head>
  <body>
    <div class="container">
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

        <!-- Content -->
        <div class="content-box">
          <!-- Review Section -->
          <div class="scrollable-section">
            @foreach ($reviews as $review)
              <div
                class="review-card"
                onclick="showReview('{{ $review->user->name }}', '{{ $review->vehicle->name }}', {{ $review->rating }}, '{{ $review->comment }}')"
              >
                <h4>{{ $review->user->name }}</h4>
                <p>{{ $review->vehicle->name }}</p>
                <p>Comment:</p>
                <div class="stars">
                  {!! str_repeat('★', $review->rating) . str_repeat('☆', 5 - $review->rating) !!}
                </div>
              </div>
            @endforeach
          </div>

          <!-- Chart Section -->
          <div class="graph-section">
            <canvas id="analyticsChart"></canvas>
            <p class="graph-description">
              Statistik pemesanan, pendapatan, serta penggunaan kendaraan dalam bentuk grafik
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <div class="modal" id="reviewModal">
      <div class="modal-content">
        <h4 id="reviewerName"></h4>
        <p><strong>Kendaraan:</strong> <span id="vehicleName"></span></p>
        <p><strong>Rating:</strong> <span id="reviewRating"></span></p>
        <p><strong>Komentar:</strong></p>
        <p id="reviewComment"></p>
        <div style="text-align: right">
          <button onclick="document.getElementById('reviewModal').style.display='none'">Tutup</button>
        </div>
      </div>
    </div>

    <!-- Scripts -->
    <script>
      const ctx = document.getElementById("analyticsChart").getContext("2d");
      new Chart(ctx, {
        type: "bar",
        data: {
          labels: {!! json_encode($chartLabels) !!},
          datasets: [{
            label: "Jumlah Pemesanan",
            data: {!! json_encode($chartData) !!},
            backgroundColor: "#4b9cd3"
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
        }
      });

      function showReview(name, vehicle, rating, comment) {
        document.getElementById("reviewerName").textContent = name;
        document.getElementById("vehicleName").textContent = vehicle;
        document.getElementById("reviewRating").textContent = "★".repeat(rating) + "☆".repeat(5 - rating);
        document.getElementById("reviewComment").textContent = comment;
        document.getElementById("reviewModal").style.display = "flex";
      }
    </script>
  </body>
</html>
