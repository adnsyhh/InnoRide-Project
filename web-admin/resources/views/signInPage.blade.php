<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Sign In - InnoRide</title>
    <link rel="stylesheet" href="{{ asset('css/signInPage.css') }}" />
  </head>
  <body>
    <div class="container">
      <div class="title">Sign In</div>

      <div class="box-wrapper">
        <div class="box">
          <div class="logo">
            <img src="{{ asset('assets/logo.png') }}" alt="Logo" />
          </div>

          <form action="{{ route('login.submit') }}" method="POST">
            @csrf
            <div class="input-group">
              <label for="email"
                ><img src="{{ asset('assets/email-icon.png') }}" alt="email-icon"
              /></label>
              <input
                type="email"
                id="email"
                name="email"
                placeholder="Email"
                required
              />
            </div>

            <div class="input-group">
              <label for="password"
                ><img src="{{ asset('assets/password-icon.png') }}" alt="lock-icon"
              /></label>
              <input
                type="password"
                id="password"
                name="password"
                placeholder="Password"
                required
              />
              <span class="toggle-password">&#128065;</span>
            </div>

            <div class="options">
              <label
                ><input type="checkbox" name="remember" /> Remember Me</label
              >
              <a href="#">Forgot Password?</a>
            </div>

            <button type="submit" class="login-btn">Login</button>
            @if ($errors->any())
                <div class="alert alert-danger">
                    <ul>
                        @foreach ($errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif
          </form>
        </div>
      </div>
    </div>
    <script>
      document.addEventListener("DOMContentLoaded", function () {
        const toggle = document.querySelector(".toggle-password");
        const passwordInput = document.getElementById("password");

        toggle.addEventListener("click", function () {
          const type =
            passwordInput.getAttribute("type") === "password"
              ? "text"
              : "password";
          passwordInput.setAttribute("type", type);
          // Ubah ikon jika ingin: contoh dari 👁️ ke 🙈
          toggle.textContent = type === "password" ? "👁️" : "🙈";
        });
      });
    </script>
  </body>
</html>
