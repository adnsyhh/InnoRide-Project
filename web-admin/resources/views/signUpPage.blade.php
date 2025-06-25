<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Sign Up - InnoRide</title>
    <link rel="stylesheet" href="{{ asset('css/signUpPage.css') }}" />
  </head>
  <body>
    <div class="container">
      <div class="title">Sign Up</div>

      <div class="box-wrapper">
        <div class="box">
          <div class="logo">
            <img src="{{ asset('assets/logo.png') }}" alt="Logo" />
          </div>

          <form action="{{ route('register.submit') }}" method="POST">
            @csrf

            <div class="input-group">
              <label><img src="{{ asset('assets/email-icon.png') }}" alt="user-icon" /></label>
              <input type="text" name="name" placeholder="Username" required />
            </div>

            <div class="input-group">
              <label
                ><img src="{{ asset('assets/email-signUp-icon.png') }}" alt="email-icon"
              /></label>
              <input type="email" name="email" placeholder="Email" required />
            </div>

            <div class="input-group">
              <label
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

            <button type="submit" class="signup-btn">Sign Up</button>
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
          toggle.textContent = type === "password" ? "👁️" : "🙈";
        });
      });
    </script>
  </body>
</html>
